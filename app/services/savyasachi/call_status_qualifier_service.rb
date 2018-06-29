# frozen_string_literal: true

class Savyasachi::CallStatusQualifierService < BaseService
  include JsonLdHelper

  # Call qualifiers with a status
  # @param [String] status Message
  # @param [Hash] options
  # @return [Boolean] 
  def call(status_id, **options)
    @status = Status.find(status_id)
    return if @status.nil?
    call_qualifiers_with_status(qualifiers, @status)
    Rails.logger.debug "After all qualifiers are called"
    true
  end

  private

  def qualifiers
    Qualifier.all
  end

  def call_qualifiers_with_status(qualifiers, status)
    qualifiers.each do |qualifier|
      update_qualifier_result_for_status(qualifier, status, false)
    end
    qualifiers.each do |qualifier|
      Rails.logger.debug "before calling qualifier endpoint: #{status.id}"
      result = call_qualifier_with_status(qualifier, status)
      update_qualifier_result_for_status(qualifier, status, result)
      Rails.logger.debug "after updating result: #{status.id} #{result}"
    end
  end

  def update_qualifier_result_for_status(qualifier, status, result = false)
    if StatusQualifierResult.where(status_id: status.id, qualifier_id: qualifier[:id]).any?
      Rails.logger.debug "Updating result status #{status.id} #{result}"
      @status_qualifier_result = StatusQualifierResult.find_by(status_id: status.id, qualifier_id: qualifier[:id])
      @status_qualifier_result.update!(result: result)
    else
      Rails.logger.debug "Creating result status #{status}"
      @status_qualifier_result = StatusQualifierResult.new(status_id: status.id,
                                                           qualifier_id: qualifier[:id],
                                                           result: result)
      @status_qualifier_result.save!
    end
  end

  def call_qualifier_with_status(qualifier, status)
    @url = qualifier[:endpoint]
    Rails.logger.debug "call url: #{status.id} #{@url}"
    return if @url.blank?
    result = process(@url, status)
    result
  rescue OpenSSL::SSL::SSLError => e
    Rails.logger.debug "SSL error: #{e}"
    nil
  rescue HTTP::ConnectionError => e
    Rails.logger.debug "HTTP ConnectionError: #{e}"
    nil
  rescue StandardError => e
    Rails.logger.debug "Error: #{e}"
    nil
  end

  def process(url, status, terminal = false)
    @url = url
    @status = status
    perform_request { |response| process_response(response, terminal) }
  end

  def perform_request(&block)
    accept = 'text/html'
    accept = 'application/json, ' + accept

    request = Request.new(:post, @url, :json => qualifier_endpoint_params).add_headers('Accept' => accept)
    request.perform(&block)
  end

  def process_response(response, terminal = false)
    return nil if response.code != 200

    if ['application/json'].include?(response.mime_type)
      body = response.body_with_limit
      json = body_to_json(body)
      Rails.logger.debug "Response #{json}"
      result = json['result']
      if (result.nil? && !json['body'].nil?)
        result = json['body']['result']
      end
      result
    end
  end

  def qualifier_endpoint_params
    {
      'status': @status.text
    }
  end
end
