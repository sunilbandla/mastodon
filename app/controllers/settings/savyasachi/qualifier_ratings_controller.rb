# frozen_string_literal: true

class Settings::Savyasachi::QualifierRatingsController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :set_account

  def index
    @qualifier_id = params[:all_qualifier_id]
    @ratings = QualifierRating.where(qualifier_id: params[:all_qualifier_id])
    if QualifierRating.exists?(qualifier_id: @qualifier_id, account_id: @account.id)
      @qualifier_rating = QualifierRating.find_by(qualifier_id: @qualifier_id, account_id: @account.id)
    else
      @qualifier_rating = QualifierRating.new
    end
  end

  def new; end

  def create
    @qualifier_rating = QualifierRating.new(rating_params)
    @qualifier_rating[:account_id] = @account.id
    @qualifier_rating[:value] = begin
                                  Integer(@qualifier_rating[:value])
                                rescue
                                  false
                                end
    unless @qualifier_rating.valid?
      flash[:error] = I18n.t('qualifiers.all.review_invalid')
      redirect_to settings_all_qualifier_qualifier_ratings_path(@qualifier_rating[:qualifier_id])
      return
    end
    if QualifierRating.exists?(qualifier_id: rating_params[:qualifier_id], account_id: @account.id)
      @qualifier_rating = QualifierRating.find_by(qualifier_id: rating_params[:qualifier_id], account_id: @account.id)
      @qualifier_rating.update(rating_params)
    elsif !@qualifier_rating.save
      flash[:error] = I18n.t('qualifiers.all.save_review_failed')
      redirect_to settings_all_qualifier_qualifier_ratings_path(@qualifier_rating[:qualifier_id])
      return
    end
    redirect_to settings_all_qualifier_qualifier_ratings_path(@qualifier_rating[:qualifier_id])
  end

  def destroy
    @qualifier_rating = QualifierRating.find_by(id: params[:id], account_id: @account.id)
    @qualifier_rating.destroy
    redirect_to settings_all_qualifier_qualifier_ratings_path(@qualifier_rating[:qualifier_id])
  end

  private

  def set_account
    @account = current_user.account
  end

  def rating_params
    params.require(:qualifier_rating).permit(:text, :value, :qualifier_id, :account_id)
  end
end
