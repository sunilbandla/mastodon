# frozen_string_literal: true

class REST::QualifierConsumerSerializer < ActiveModel::Serializer
  attributes :id, :enabled, :trial, :active,
             :qualifier_id, :account_id, :payment_date

  has_many :qualifier_filters, serializer: REST::QualifierFilterSerializer

  def qualifier_filters
    QualifierFilter.where(qualifier_consumer_id: object.id).all || []
  end
end
