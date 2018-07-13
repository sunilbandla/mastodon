# frozen_string_literal: true

class Api::V1::Savyasachi::FolderLabelsController < Api::BaseController
  include Authorization

  before_action :authorize_if_got_token
  before_action -> { doorkeeper_authorize! :write }, only:  [:create, :update, :destroy]
  before_action :require_user!

  respond_to :json

  def index
    if current_user[:account_id]
      @folder_labels = FolderLabel.where(account_id: current_user[:account_id])
    end
    render json: @folder_labels, each_serializer: REST::FolderLabelSerializer
  end

  def show
    @folder_label = FolderLabel.find_by(id: params[:id], account_id: current_user[:account_id])
    render json: @folder_label, serializer: REST::FolderLabelSerializer
  end

  def create
    @folder_label = FolderLabel.create!(
      account_id: current_user[:account_id],
      name: folder_label_params[:name]
    )
    Rails.logger.debug "Sucessfully created #{@folder_label[:account_id]} #{@folder_label[:name]}"
    render json: @folder_label, serializer: REST::FolderLabelSerializer
  end

  def new
    render_empty
  end

  def edit
    render_empty
  end

  def update
    if !FolderLabel.exists?(id: params[:id], account_id: current_user[:account_id])
      render json: { error: "Folder #{params[:id]} not found" }, status: 404
    else
      @folder_label = FolderLabel.find_by(id: params[:id], account_id: current_user[:account_id])
      if @folder_label.update!(folder_label_params)
        render json: @folder_label, serializer: REST::FolderLabelSerializer
      else
        render json: { error: "Error while saving" }, status: 400
      end
    end
  end

  def destroy
    if !FolderLabel.exists?(id: params[:id], account_id: current_user[:account_id])
      render json: { error: "Folder #{params[:id]} not found" }, status: 404
    else
      @folder_label = FolderLabel.find_by(id: params[:id], account_id: current_user[:account_id])
      @folder_label.destroy
    end
  end

  private

  def authorize_if_got_token
    request_token = Doorkeeper::OAuth::Token.from_request(request, *Doorkeeper.configuration.access_token_methods)
    doorkeeper_authorize! :read if request_token
  end

  def folder_label_params
    params.require(:folder_label).permit(:id, :name)
  end
end
