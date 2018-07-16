# frozen_string_literal: true

class Settings::Savyasachi::AllQualifiersController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_account
  before_action :set_qualifier, only: [:show]

  helper_method :get_masked_endpoint

  def index
    @qualifiers = Qualifier.all
  end

  def show; end

  private

  def set_account
    @account = current_user.account
  end

  def set_qualifier
    @qualifier = Qualifier.find(params[:id])
    @installed_qualifier = QualifierConsumer.find_by(qualifier_id: params[:id], account_id: @account.id)
  end

  def get_masked_endpoint(endpoint)
    url = if URI.parse(endpoint).scheme.nil?
            "https://#{endpoint}"
          else
            endpoint
          end
    uri = URI.parse(url)
    "https://#{uri.host.downcase}/***"
  end
end
