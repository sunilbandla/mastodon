# frozen_string_literal: true

class DistributeStatusService < BaseService
  # Fetch and notify remote users mentioned
  # @param [Status.id] status_id
  # @return [Status]
  def call(status_id)
    status = Status.find(status_id)

    process_mentions_service.call(status)
    process_hashtags_service.call(status)

    LinkCrawlWorker.perform_async(status.id) unless status.spoiler_text?
    DistributionWorker.perform_async(status.id)
    Pubsubhubbub::DistributionWorker.perform_async(status.stream_entry.id)
    ActivityPub::DistributionWorker.perform_async(status.id)
    ActivityPub::ReplyDistributionWorker.perform_async(status.id) if status.reply? && status.thread.account.local?

    status
  end

  private

  def process_mentions_service
    ProcessMentionsService.new
  end

  def process_hashtags_service
    ProcessHashtagsService.new
  end
end
