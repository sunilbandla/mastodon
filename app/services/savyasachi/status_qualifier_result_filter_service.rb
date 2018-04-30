# frozen_string_literal: true

class Savyasachi::StatusQualifierResultFilterService < BaseService
  # Filter a status update, based on user's qualifiers' result
  # @param [String] status Message
  # @param [Account ID] receiver_id Receiver account id to which to post
  # @param [Hash] options
  # @return [Boolean] 
  def filter?(status, receiver_id, **options)
    QualifierConsumer.where(user_id: receiver_id).each do |qualifier|
      if StatusQualifierResult.where(status_id: status.id, qualifier_id: qualifier[:id]).any?
        Rails.logger.debug "found StatusQualifierResult #{qualifier[:id]}"
        status_qualifier_result = StatusQualifierResult.find_by(status_id: status.id, qualifier_id: qualifier[:id])
        Rails.logger.debug "return StatusQualifierResult result #{status_qualifier_result.result}"
        return true if status_qualifier_result.result?
      end
    end
    Rails.logger.debug "return filter? false"
    false
  end

  private

end
