# frozen_string_literal: true

class Savyasachi::StatusQualifierResultFilterService < BaseService
  # Filter a status update, based on user's qualifiers' result
  # @param [String] status Message
  # @param [Account ID] receiver_id Receiver account id to which to post
  # @return [Boolean]
  def filter?(status, receiver_id)
    QualifierConsumer.where(account_id: receiver_id).each do |qualifier|
      if StatusQualifierResult.where(status_id: status.id, qualifier_id: qualifier[:qualifier_id]).any?
        status_qualifier_result = StatusQualifierResult.find_by(status_id: status.id, qualifier_id: qualifier[:qualifier_id])
        result = status_qualifier_result.result
        qualifier_filters = QualifierFilter.where(qualifier_consumer_id: qualifier[:id])
        qualifier_filters.each do |qualifier_filter|
          unless qualifier_filter[:action_config_id] &&
                 ActionConfig.exists?(qualifier_filter.action_config_id)
            next
          end
          unless qualifier_filter[:filter_condition_id] &&
                 FilterCondition.exists?(qualifier_filter[:filter_condition_id])
            next
          end
          filter_condition = FilterCondition.find(qualifier_filter[:filter_condition_id])
          action_config = ActionConfig.find(qualifier_filter[:action_config_id])
          if filter_condition[:value] != result
            next
          end
          return true
        end
      end
    end
    false
  end
end
