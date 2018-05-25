# frozen_string_literal: true

class Api::V1::Savyasachi::FolderLabelsController < Api::BaseController
  include Authorization

  before_action :authorize_if_got_token
  # before_action -> { doorkeeper_authorize! :write }, only:  [:create, :destroy]
  # before_action :require_user!

  respond_to :json

  def index
    @folder_labels = FolderLabel.all
    render json: @folder_labels, each_serializer: REST::FolderLabelSerializer
  end

  def show
    @folder_label = FolderLabel.find(params[:id])
    render json: @folder_label, serializer: REST::FolderLabelSerializer
  end

  def create
    @folder_label = FolderLabel.new(
      user_id: folder_label_params[:user_id],
      name: folder_label_params[:name]
    )
    if @folder_label.save!
      Rails.logger.debug "Sucessfully saved #{@folder_label[:id]}"
      render json: @folder_label, serializer: REST::FolderLabelSerializer
    else
      Rails.logger.debug "Error while creating"
      render json: { error: 'Error while creating ' }, status: 400
    end
  end

  def new
    render_empty
  end

  def edit
    render_empty
  end

  def update
    @folder_label = FolderLabel.find(params[:id])
    if @folder_label.update!(folder_label_params)
      render json: @folder_label, serializer: REST::FolderLabelSerializer
    else
      render json: { error: 'Error while saving' }, status: 400
    end
  end

  def destroy
    @folder_label = FolderLabel.find(params[:id])
    @folder_label.destroy
  end

  private

  def authorize_if_got_token
    request_token = Doorkeeper::OAuth::Token.from_request(request, *Doorkeeper.configuration.access_token_methods)
    doorkeeper_authorize! :read if request_token
  end

  def folder_label_params
    params.require(:folder_label).permit(:user_id, :name)
  end
end
