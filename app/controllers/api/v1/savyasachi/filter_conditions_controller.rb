# frozen_string_literal: true

class Api::V1::Savyasachi::FilterConditionsController < Api::BaseController
  include Authorization

  before_action :authorize_if_got_token
  before_action -> { doorkeeper_authorize! :write }, only:  [:create, :destroy]
  before_action :require_user!

  respond_to :json

  def index
    @filter_conditions = FilterCondition.all
    render json: @filter_conditions, each_serializer: REST::FilterConditionSerializer
  end

  def show
    @filter_condition = FilterCondition.find(params[:id])
    render json: @filter_condition, serializer: REST::FilterConditionSerializer
  end

  def create
    render_empty
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

  def filter_condition_params
    params.require(:filter_condition).permit(:id, :name, :value)
  end
end
