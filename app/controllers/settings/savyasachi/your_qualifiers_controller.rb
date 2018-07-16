# frozen_string_literal: true

class Settings::Savyasachi::YourQualifiersController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_account
  before_action :set_qualifier, only: [:show, :edit, :update, :destroy]

  def index
    @qualifiers = Qualifier.where(account_id: @account.id)
  end

  def show; end

  def new
    @qualifier = Qualifier.new
  end

  def create
    # TODO: add not null validations for all columns
    @qualifier = Qualifier.new(qualifier_params)
    @qualifier[:account_id] = @account.id
    # TODO: remove price limit
    @qualifier[:price] = 0
    if @qualifier.save!
      redirect_to settings_your_qualifier_path(@qualifier)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    # TODO: remove price limit
    @qualifier[:price] = 0
    if @qualifier.update(qualifier_params)
      redirect_to settings_your_qualifier_path(@qualifier)
    else
      render 'edit'
    end
  end

  def destroy
    @qualifier.destroy
    redirect_to settings_your_qualifiers_path
  end

  private

  def qualifier_params
    params.require(:qualifier).permit(:name, :description, :qualifier_category_id,
                                      :endpoint, :price, :version, :account_id, :headers)
  end

  def set_account
    @account = current_user.account
  end

  def set_qualifier
    @qualifier = Qualifier.find_by(id: params[:id], account_id: @account.id)
  end
end
