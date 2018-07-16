# frozen_string_literal: true

class REST::QualifierSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :endpoint,
             :qualifier_category_id, :account_id, :price, :version
end
