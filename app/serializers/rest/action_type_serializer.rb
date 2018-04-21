# frozen_string_literal: true

class REST::ActionTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :code
end
