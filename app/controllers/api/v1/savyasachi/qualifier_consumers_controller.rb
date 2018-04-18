# frozen_string_literal: true

class Api::V1::Savyasachi::QualifierConsumersController < Api::BaseController
  include Authorization

  before_action :authorize_if_got_token
  # before_action -> { doorkeeper_authorize! :write }, only:  [:create, :destroy]
  # before_action :require_user!

  respond_to :json

  def index
    @qualifier_consumers = QualifierConsumer.all
    render json: @qualifier_consumers, each_serializer: REST::QualifierConsumerSerializer
  end

  def show
    @qualifier_consumer = QualifierConsumer.find(params[:id])
    render json: @qualifier_consumer, serializer: REST::QualifierConsumerSerializer
  end

  def create
    @qualifier_consumer = QualifierConsumer.new(
      qualifier_id: qualifier_consumer_params[:qualifier_id],
      user_id: qualifier_consumer_params[:user_id],
      payment_date: qualifier_consumer_params[:payment_date],
      enabled: qualifier_consumer_params[:enabled],
      trial: qualifier_consumer_params[:trial],
      active: qualifier_consumer_params[:active]
    )
    if @qualifier_consumer.save!
      Rails.logger.debug "Qualifier consumer saved #{@qualifier_consumer[:id]}"
      render json: @qualifier_consumer, serializer: REST::QualifierConsumerSerializer
    else
      Rails.logger.debug "Qualifier consumer not saved"
      render json: { error: 'Error while creating qualifier consumer' }, status: 400
    end
  end

  def new
    render_empty
  end

  def edit
    render_empty
  end

  def update
    @qualifier_consumer = QualifierConsumer.find(params[:id])
    if @qualifier_consumer.update!(qualifier_consumer_params)
      render json: @qualifier_consumer, serializer: REST::QualifierConsumerSerializer
    else
      render json: { error: 'Error while saving qualifier consumer' }, status: 400
    end
  end

  def destroy
    @qualifier_consumer = QualifierConsumer.find(params[:id])
    @qualifier_consumer.destroy
  end

  private

  def authorize_if_got_token
    request_token = Doorkeeper::OAuth::Token.from_request(request, *Doorkeeper.configuration.access_token_methods)
    doorkeeper_authorize! :read if request_token
  end

  def qualifier_consumer_params
    params.require(:qualifier_consumer).permit(
      :enabled, :trial, :active, :qualifier_id, :user_id, :payment_date)
  end
end
