# frozen_string_literal: true

class Settings::Savyasachi::InstalledQualifiersController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_account
  before_action :set_installed_qualifier, only: [:show, :edit, :update, :destroy]

  MOVE_TO_FOLDER_ACTION_TYPE_ID = 2

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
      flash[:notice] = I18n.t('qualifiers.installed.create_success')
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
    unless FolderLabel.where(account_id: @account.id).size > 0
      @installed_qualifier.qualifier_filters[0].action_config.build_folder_label
    end
  end

  def update
    installed_qualifier_params[:qualifier_filters_attributes].values.each do |filter|
      if filter[:filter_condition_id].blank?
        flash[:error] = I18n.t('qualifiers.installed.invalid_filter_condition')
        redirect_to edit_settings_installed_qualifier_path(@installed_qualifier[:id])
        return
      end
      folder_label_id = action_config_params(filter)[:folder_label_id]
      if is_folder_required(action_config_params(filter))
        if !folder_label_id.nil? &&
          !FolderLabel.exists?(id: folder_label_id, account_id: @account.id)
          raise ActiveRecord::RecordNotFound
        end
        return if folder_label_id.nil? && !create_new_folder(filter)
      end
      if action_config_params(filter)[:id].blank?
        @action_config = ActionConfig.new(action_config_params(filter))
        if is_folder_required(action_config_params(filter)) && @action_config[:folder_label_id].nil? &&
           !@folder_label.nil? && !@folder_label[:id].nil?
          @action_config[:folder_label_id] = @folder_label[:id]
        end
        unless is_folder_required(action_config_params(filter))
          @action_config[:folder_label_id] = nil
        end
        return if action_config_invalid?(@action_config, @installed_qualifier[:id])
        @action_config.save!
      else
        @action_config = ActionConfig.find(action_config_params(filter)[:id])
        return if action_config_invalid?(@action_config, @installed_qualifier[:id])
        updated_action_config = action_config_params(filter)
        if is_folder_required(action_config_params(filter)) && @action_config[:folder_label_id].nil? &&
           !@folder_label.nil? && !@folder_label[:id].nil?
          updated_action_config[:folder_label_id] = @folder_label[:id]
        end
        unless is_folder_required(action_config_params(filter))
          updated_action_config[:folder_label_id] = nil
        end
        @action_config.update!(action_type_id: updated_action_config[:action_type_id],
                               folder_label_id: updated_action_config[:folder_label_id])
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
      flash[:notice] = I18n.t('generic.changes_saved_msg')
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
    flash[:notice] = I18n.t('qualifiers.installed.uninstall_success')
    redirect_to settings_installed_qualifiers_path
  end

  private

  def create_new_folder(filter)
    unless is_folder_required(action_config_params(filter))
      return true
    end
    new_folder_config = new_folder_params(filter)
    new_folder_label = new_folder_config[:name]
    if new_folder_label.nil? || new_folder_label.blank?
      flash[:error] = I18n.t('qualifiers.installed.empty_folder')
      redirect_to edit_settings_installed_qualifier_path(@installed_qualifier[:id])
      return false
    end
    if FolderLabel.exists?(name: new_folder_label, account_id: @account.id)
      @folder_label = FolderLabel.find_by(
        account_id: current_user[:account_id],
        name: new_folder_label
      )
    else
      @folder_label = FolderLabel.new(
        account_id: current_user[:account_id],
        name: new_folder_label
      )
      unless @folder_label.save
        flash[:error] = I18n.t('qualifiers.installed.invalid_folder')
        redirect_to edit_settings_installed_qualifier_path(@installed_qualifier[:id])
        return false
      end
    end
    return true
  end

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
                                                                            :folder_label_id,
                                                                            :id,
                                                                            folder_label_attributes: [:name]]])
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
    qualifier_filter.require(:action_config_attributes).permit(:id, :action_type_id, :folder_label_id,
      folder_label_attributes: [:name])
  end

  def new_folder_params(qualifier_filter)
    qualifier_filter.require(:action_config_attributes).require(:folder_label_attributes).permit(:name)
  end

  def action_config_invalid?(action_config, id)
    unless action_config.valid?
      flash[:error] = I18n.t('qualifiers.installed.invalid_action_config')
      redirect_to edit_settings_installed_qualifier_path(id)
      return true
    end
    false
  end

  def is_folder_required(action_config)
    return action_config[:action_type_id] == MOVE_TO_FOLDER_ACTION_TYPE_ID.to_s
  end
end
