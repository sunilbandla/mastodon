# frozen_string_literal: true

class REST::QualifierConsumerSerializer < ActiveModel::Serializer
  attributes :id, :enabled, :trial, :active,
             :qualifier_id, :account_id, :payment_date

  has_many :qualifier_filters, serializer: REST::QualifierFilterSerializer

  def qualifier_filters
    QualifierFilter.where(qualifier_consumer_id: object.id).all || []
  end

  def id
    object.id
  end

  def qualifier_id
    object.qualifier_id
  end

  def account_id
    object.account_id
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
