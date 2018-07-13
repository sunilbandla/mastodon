# frozen_string_literal: true

class Api::V1::Savyasachi::ActionTypesController < Api::BaseController
  include Authorization

  before_action :authorize_if_got_token
  before_action -> { doorkeeper_authorize! :write }, only:  [:create, :destroy]
  before_action :require_user!

  respond_to :json

  def index
    @action_types = ActionType.all
    render json: @action_types, each_serializer: REST::ActionTypeSerializer
  end

  def show
    @action_type = ActionType.find(params[:id])
    render json: @action_type, serializer: REST::ActionTypeSerializer
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

  def action_type_params
    params.require(:action_type).permit(:id, :name, :code)
  end
end
