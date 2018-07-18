# frozen_string_literal: true

class Settings::Savyasachi::InstalledQualifiersController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_account
  before_action :set_installed_qualifier, only: [:show, :edit, :update, :destroy]

  def index
    @installed_qualifiers = QualifierConsumer.where(account_id: @account.id)
  end

  def show; end

  def create
    if QualifierConsumer.exists?(qualifier_id: params[:qualifier_id], account_id: @account.id)
      redirect_to settings_installed_qualifiers_path
      return
    end
    installed_qualifier = QualifierConsumer.new(
      qualifier_id: params[:qualifier_id],
      account_id: @account.id,
      enabled: true,
      trial: true,
      active: true
    )
    if installed_qualifier.save
      redirect_to settings_installed_qualifier_path(installed_qualifier)
      return
    end
    redirect_to settings_all_qualifier_path(id: params[:qualifier_id])
  end

  def edit
    if @installed_qualifier.qualifier_filters.empty?
      @installed_qualifier.qualifier_filters.build
      @installed_qualifier.qualifier_filters[0].build_action_config
    end
  end

  def update
    installed_qualifier_params[:qualifier_filters_attributes].values.each do |filter|
      folder_label_id = action_config_params(filter)[:folder_label_id]
      unless FolderLabel.exists?(id: folder_label_id, account_id: @account.id)
        raise ActiveRecord::RecordNotFound
      end
      if filter[:filter_condition_id].blank?
        flash[:error] = I18n.t('qualifiers.installed.invalid_filter_condition')
        redirect_to edit_settings_installed_qualifier_path(@installed_qualifier[:id])
        return
      end
      if action_config_params(filter)[:id].blank?
        @action_config = ActionConfig.new(action_config_params(filter))
        return if action_config_invalid?(@action_config, @installed_qualifier[:id])
        @action_config.save!
      else
        @action_config = ActionConfig.find(action_config_params(filter)[:id])
        return if action_config_invalid?(@action_config, @installed_qualifier[:id])
        @action_config.update!(action_config_params(filter))
      end
      if filter[:id].blank?
        @filter = QualifierFilter.new(filter_condition_id: filter[:filter_condition_id],
                                      qualifier_consumer_id: @installed_qualifier[:id],
                                      action_config_id: @action_config[:id])
        @filter.save!
      else
        @filter = QualifierFilter.find(filter[:id])
        @filter.update!(filter_condition_id: filter[:filter_condition_id],
                        action_config_id: @action_config[:id])
      end
    end
    if @installed_qualifier.update!(qualifier_consumer_params)
      redirect_to settings_installed_qualifier_path(@installed_qualifier)
    else
      flash[:error] = I18n.t('qualifiers.installed.invalid_qualifier_filter')
      redirect_to edit_settings_installed_qualifier_path(@installed_qualifier[:id])
    end
  end

  def destroy
    @installed_qualifier.qualifier_filters.each do |filter|
      config = ActionConfig.find(filter[:action_config_id])
      filter&.destroy!
      config&.destroy!
    end
    @installed_qualifier.destroy!
    redirect_to settings_installed_qualifiers_path
  end

  private

  def qualifier_consumer_params
    params.require(:qualifier_consumer).permit(:enabled, :trial, :active,
                                               :qualifier_id, :account_id)
  end

  def installed_qualifier_params
    params.require(:qualifier_consumer)
          .permit(:id, :qualifier_id, :account_id,
                  :enabled, :trial, :active, :payment_date,
                  qualifier_filters_attributes: [:qualifier_consumer_id,
                                                 :filter_condition_id, :id,
                                                 action_config_attributes: [:action_type_id,
                                                                            :folder_label_id, :id]])
  end

  def set_account
    @account = current_user.account
  end

  def set_installed_qualifier
    @installed_qualifier =
      if QualifierConsumer.exists?(id: params[:id], account_id: @account.id)
        QualifierConsumer.find_by(id: params[:id], account_id: @account.id)
      else
        QualifierConsumer.find_by(qualifier_id: params[:id], account_id: @account.id)
      end
  end

  def action_config_params(qualifier_filter)
    qualifier_filter.require(:action_config_attributes).permit(:id, :action_type_id, :folder_label_id)
  end

  def action_config_invalid?(action_config, id)
    unless action_config.valid?
      flash[:error] = I18n.t('qualifiers.installed.invalid_action_config')
      redirect_to edit_settings_installed_qualifier_path(id)
      return true
    end
    false
  end
end
