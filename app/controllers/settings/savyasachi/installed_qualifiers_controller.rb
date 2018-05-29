# frozen_string_literal: true

class Settings::Savyasachi::InstalledQualifiersController < ApplicationController

  layout 'admin'

  before_action :authenticate_user!
  before_action :set_account
  before_action :set_installed_qualifier, only: [:show, :edit, :update, :destroy]

  def index
    @installed_qualifiers = QualifierConsumer.where(account_id: @account.id)
  end

  def show
  end

  def edit
    Rails.logger.debug "in edit #{@installed_qualifier.qualifier_filters.empty?}"
    if @installed_qualifier.qualifier_filters.empty?
      # TODO verify
      @installed_qualifier.qualifier_filters.build
    end
  end

  def update
    Rails.logger.debug "in update #{installed_qualifier_params}"
    installed_qualifier_params[:qualifier_filters_attributes].values.each do |filter|
      Rails.logger.debug "filter #{filter}"
      folder_label_id = action_config_params(filter)[:folder_label_id]
      if !FolderLabel.exists?(id: folder_label_id, account_id: @account.id)
        raise ActiveRecord::RecordNotFound
      end
      if action_config_params(filter)[:id].blank?
        # TODO check this works for new installed qualifier
        @action_config = ActionConfig.new(action_config_params(filter))
        @action_config.save!
        filter[:action_config_attributes][:id] = @action_config[:id]
      else
        @action_config = ActionConfig.find(action_config_params(filter)[:id])
        @action_config.update!(action_config_params(filter))
      end
    end
    if @installed_qualifier.update!(installed_qualifier_params)
      redirect_to settings_installed_qualifier_path(@installed_qualifier)
    else
      render 'edit'
    end
  end

  def destroy
    @installed_qualifier.destroy!
    redirect_to settings_installed_qualifiers_path
  end

  private

  def installed_qualifier_params
    params.require(:qualifier_consumer).permit(
      :id, :qualifier_id, :account_id, :enabled, :trial, :active, :payment_date,
       qualifier_filters_attributes: [:qualifier_consumer_id, :filter_condition_id, :id,
        action_config_attributes: [:action_type_id, :folder_label_id, :id]])
  end

  def set_account
    @account = current_user.account
  end

  def set_installed_qualifier
    @installed_qualifier = QualifierConsumer.find_by(id: params[:id], account_id: @account.id)
  end

  def action_config_params(qualifier_filter)
    qualifier_filter.require(:action_config_attributes).permit(
      :id, :action_type_id, :folder_label_id)
  end
end
