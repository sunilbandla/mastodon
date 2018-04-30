# frozen_string_literal: true

class Savyasachi::ProcessStatusWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'pull', retry: 0

  def perform(status_id)
    Savyasachi::CallStatusQualifierService.new.call(status_id)
    Rails.logger.debug "before calling distribute service"
    DistributeStatusService.new.call(status_id)
  end
end
