# frozen_string_literal: true

require 'singleton'

class FolderManager
  include Singleton

  MAX_ITEMS = 400
  KEY_PREFIX = "folder:"
  MOVE_TO_FOLDER_ACTION_TYPE = "moveToFolder"
  MOVE_TO_FOLDER_ACTION_TYPE_ID = 2

  def key(account_id, folder_id, sub_type = nil)
    # TODO remove account_id input
    account_id = nil
    return "#{KEY_PREFIX}#{folder_id}" unless sub_type

    "#{KEY_PREFIX}#{folder_id}:#{sub_type}"
  end

  def push_to_folder(account, status)
    Rails.logger.debug "push_to_folder #{account} #{status.id}"
    QualifierConsumer.where(account_id: account.id).each do |qualifier|
      Rails.logger.debug "push_to_folder  qualifier_consumer_id: #{qualifier.qualifier_id}"
      if StatusQualifierResult.where(status_id: status.id, qualifier_id: qualifier[:qualifier_id]).any?
        status_qualifier_result = StatusQualifierResult.find_by(status_id: status.id, qualifier_id: qualifier[:qualifier_id])
        Rails.logger.debug "push_to_folder result #{status_qualifier_result.result}"
        result = status_qualifier_result.result
        qualifier_filters = QualifierFilter.where(qualifier_consumer_id: qualifier[:id])
        qualifier_filters.each do |qualifier_filter|
          Rails.logger.debug "push_to_folder filter_action_id:#{qualifier_filter[:action_config_id]} #{qualifier_filter.filter_condition_id}"
          if !(qualifier_filter[:action_config_id] &&
             ActionConfig.exists?(qualifier_filter.action_config_id))
             Rails.logger.debug "No action config"
            next
          end
          if !(qualifier_filter[:filter_condition_id] &&
             FilterCondition.exists?(qualifier_filter[:filter_condition_id]))
             Rails.logger.debug "No filter condition"
            next
          end
          filter_condition = FilterCondition.find(qualifier_filter[:filter_condition_id])
          action_config = ActionConfig.find(qualifier_filter[:action_config_id])
          Rails.logger.debug "push_to_folder condition_value:#{filter_condition[:value]} action_type:#{action_config[:action_type_id]}"
          if filter_condition[:value] != result
            Rails.logger.debug "push_to_folder filter_value != qualifier result; next please"
            next
          end
          if action_config[:action_type_id] != MOVE_TO_FOLDER_ACTION_TYPE_ID
            next
          end
          if StatusFolder.exists?(status_id: status.id, folder_label_id: action_config[:folder_label_id])
            next
          end
          Rails.logger.debug "push_to_folder save  #{status.id} #{action_config[:folder_label_id]}"
          status_folder = StatusFolder.new(status_id: status.id, folder_label_id: action_config[:folder_label_id])
          status_folder.save!
          Rails.logger.debug "calling add_to_folder acc:#{account.id} #{status.id} folder_id:#{action_config[:folder_label_id]}"
          add_to_folder(:folder, account.id, status, action_config[:folder_label_id])
          Rails.logger.debug "calling trim folder_id:#{action_config[:folder_label_id]}"
          trim(:folder, account.id, action_config[:folder_label_id])
          timeline_key = key(account.id, action_config[:folder_label_id])
          if push_update_required?(timeline_key)
            Rails.logger.debug "calling PushUpdateWorker timeline key: #{timeline_key}"
            PushUpdateWorker.perform_async(account.id, status.id, timeline_key)
          end
        end
      end
    end
    true
  end

  def unpush_from_folders(account, status)
    StatusFolder.joins(:folder_label).where(folder_labels: { account_id: account.id }).each do |status_folder|
      timeline_key = key(account.id, status_folder.folder_label_id)
      Rails.logger.debug "remove_from_folder #{account.id} #{status.id} #{status_folder.folder_label_id}"
      return false unless remove_from_folder(:folder, account.id, status, status_folder.folder_label_id)
      Redis.current.publish(timeline_key, Oj.dump(event: :delete, payload: status.id.to_s))
    end
    true
  end

  def trim(type, account_id, folder_label_id)
    timeline_key = key(account_id, folder_label_id)
    reblog_key   = key(account_id, folder_label_id, 'reblogs')

    # Remove any items past the MAX_ITEMS'th entry in our feed
    redis.zremrangebyrank(timeline_key, '0', (-(FeedManager::MAX_ITEMS + 1)).to_s)

    # Get the score of the REBLOG_FALLOFF'th item in our feed, and stop
    # tracking anything after it for deduplication purposes.
    falloff_rank  = FeedManager::REBLOG_FALLOFF - 1
    falloff_range = redis.zrevrange(timeline_key, falloff_rank, falloff_rank, with_scores: true)
    falloff_score = falloff_range&.first&.last&.to_i || 0

    # Get any reblogs we might have to clean up after.
    redis.zrangebyscore(reblog_key, 0, falloff_score).each do |reblogged_id|
      # Remove it from the set of reblogs we're tracking *first* to avoid races.
      redis.zrem(reblog_key, reblogged_id)
      # Just drop any set we might have created to track additional reblogs.
      # This means that if this reblog is deleted, we won't automatically insert
      # another reblog, but also that any new reblog can be inserted into the
      # feed.
      redis.del(key(account_id, folder_label_id, "reblogs:#{reblogged_id}"))
    end
  end

  def populate_folders(account)
    limit  = FeedManager::MAX_ITEMS / 2

    FolderLabel.find_by(account_id: account.id).each do |folder_label|
      statuses = Status.as_folder_timeline(account, folder_label.id)
                      .paginate_by_max_id(limit)

      next if statuses.empty?

      statuses.each do |status|
        add_to_folder(:folder, account.id, status, folder_label.id)
      end
    end
  end

  private

  def redis
    Redis.current
  end

  def push_update_required?(timeline_id)
    redis.exists("subscribed:#{timeline_id}")
  end

  # Adds a status to an account's feed, returning true if a status was
  # added, and false if it was not added to the feed. Note that this is
  # an internal helper: callers must call trim or push updates if
  # either action is appropriate.
  def add_to_folder(timeline_type, account_id, status, folder_label_id)
    timeline_key = key(account_id, folder_label_id)
    reblog_key   = key(account_id, folder_label_id, 'reblogs')

    if status.reblog?
      # If the original status or a reblog of it is within
      # REBLOG_FALLOFF statuses from the top, do not re-insert it into
      # the feed
      rank = redis.zrevrank(timeline_key, status.reblog_of_id)

      return false if !rank.nil? && rank < FeedManager::REBLOG_FALLOFF

      reblog_rank = redis.zrevrank(reblog_key, status.reblog_of_id)

      if reblog_rank.nil?
        # This is not something we've already seen reblogged, so we
        # can just add it to the feed (and note that we're
        # reblogging it).
        redis.zadd(timeline_key, status.id, status.id)
        redis.zadd(reblog_key, status.id, status.reblog_of_id)
      else
        # Another reblog of the same status was already in the
        # REBLOG_FALLOFF most recent statuses, so we note that this
        # is an "extra" reblog, by storing it in reblog_set_key.
        reblog_set_key = key(account_id, folder_label_id, "reblogs:#{status.reblog_of_id}")
        redis.sadd(reblog_set_key, status.id)
        return false
      end
    else
      # A reblog may reach earlier than the original status because of the
      # delay of the worker deliverying the original status, the late addition
      # by merging timelines, and other reasons.
      # If such a reblog already exists, just do not re-insert it into the feed.
      rank = redis.zrevrank(reblog_key, status.id)

      return false unless rank.nil?

      redis.zadd(timeline_key, status.id, status.id)
    end

    true
  end

  # Removes an individual status from a feed, correctly handling cases
  # with reblogs, and returning true if a status was removed. As with
  # `add_to_folder`, this does not trigger push updates, so callers must
  # do so if appropriate.
  def remove_from_folder(timeline_type, account_id, status, folder_label_id)
    timeline_key = key(account_id, folder_label_id)

    if status.reblog?
      # 1. If the reblogging status is not in the feed, stop.
      status_rank = redis.zrevrank(timeline_key, status.id)
      return false if status_rank.nil?

      # 2. Remove reblog from set of this status's reblogs.
      reblog_set_key = key(account_id, folder_label_id, "reblogs:#{status.reblog_of_id}")

      redis.srem(reblog_set_key, status.id)
      # 3. Re-insert another reblog or original into the feed if one
      # remains in the set. We could pick a random element, but this
      # set should generally be small, and it seems ideal to show the
      # oldest potential such reblog.
      other_reblog = redis.smembers(reblog_set_key).map(&:to_i).sort.first

      redis.zadd(timeline_key, other_reblog, other_reblog) if other_reblog

      # 4. Remove the reblogging status from the feed (as normal)
      # (outside conditional)
    else
      # If the original is getting deleted, no use for reblog references
      redis.del(key(account_id, folder_label_id, "reblogs:#{status.id}"))
    end

    redis.zrem(timeline_key, status.id)
  end
end
