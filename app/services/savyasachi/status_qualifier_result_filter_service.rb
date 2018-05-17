# frozen_string_literal: true

class Savyasachi::StatusQualifierResultFilterService < BaseService
  # Filter a status update, based on user's qualifiers' result
  # @param [String] status Message
  # @param [Account ID] receiver_id Receiver account id to which to post
  # @param [Hash] options
  # @return [Boolean] 
  def filter?(status, receiver_id, **options)
    QualifierConsumer.where(account_id: receiver_id).each do |qualifier|
      if StatusQualifierResult.where(status_id: status.id, qualifier_id: qualifier[:id]).any?
        status_qualifier_result = StatusQualifierResult.find_by(status_id: status.id, qualifier_id: qualifier[:id])
        Rails.logger.debug "StatusQualifierResult result #{status_qualifier_result.result}"
        result = status_qualifier_result.result
        qualifier_filters = QualifierFilter.where(qualifier_consumer_id: qualifier[:id])
        Rails.logger.debug "StatusQualifierResultFilterService: qualifier_filters count #{qualifier_filters.count}"
        qualifier_filters.each do |qualifier_filter|
          Rails.logger.debug "StatusQualifierResultFilterService: qualifier_filter  #{qualifier_filter[:action_config_id]} #{qualifier_filter.filter_condition_id}"
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
          Rails.logger.debug "result  #{filter_condition[:value]} #{action_config[:action_type_id]}"
          if filter_condition[:value] != result
            next
          end
          Rails.logger.debug "return StatusQualifierResultFilterService.filter? true"
          return true
        end
      end
    end
    Rails.logger.debug "return StatusQualifierResultFilterService.filter? false"
    false
  end

  private

end
