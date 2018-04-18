# frozen_string_literal: true

class REST::QualifierConsumerSerializer < ActiveModel::Serializer
  attributes :id, :enabled, :trial, :active,
             :qualifier_id, :user_id, :payment_date

  def id
    object.id
  end

  def qualifier_id
    object.qualifier_id
  end

  def user_id
    object.user_id
  end

  def enabled
    object.enabled
  end

  def trial
    object.trial
  end

  def active
    object.active
  end

  def payment_date
    object.payment_date.as_json
  end
  
end
