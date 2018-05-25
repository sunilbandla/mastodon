# frozen_string_literal: true

class Api::V1::Savyasachi::QualifiersController < Api::BaseController
  include Authorization

  before_action :authorize_if_got_token
  # before_action -> { doorkeeper_authorize! :write }, only:  [:create, :destroy]
  # before_action :require_user!

  respond_to :json

  def index
    @qualifiers = Qualifier.all
    render json: @qualifiers, each_serializer: REST::QualifierSerializer
  end

  def show
    @qualifier = Qualifier.find(params[:id])
    render json: @qualifier, serializer: REST::QualifierSerializer
  end

  def create
    @qualifier = Qualifier.new(
      name: qualifier_params[:name],
      description: qualifier_params[:description],
      endpoint: qualifier_params[:endpoint],
      qualifier_category_id: qualifier_params[:qualifier_category_id],
      price: qualifier_params[:price],
      version: qualifier_params[:version],
      user_id: qualifier_params[:user_id]
    )
    if @qualifier.save
      Rails.logger.debug "Qualifier saved #{@qualifier[:id]}"
    else
      Rails.logger.debug "Qualifier not saved"
    end

    render json: @qualifier, serializer: REST::QualifierSerializer
  end

  def new
    render_empty
  end

  def edit
    render_empty
  end

  def update
    render_empty
  end

  def destroy
    render_empty
  end

  private

  def authorize_if_got_token
    request_token = Doorkeeper::OAuth::Token.from_request(request, *Doorkeeper.configuration.access_token_methods)
    doorkeeper_authorize! :read if request_token
  end

  def qualifier_params
    params.require(:qualifier).permit(
      :name, :description, :qualifier_category_id, :endpoint, :price, :version, :user_id)
  end
end
