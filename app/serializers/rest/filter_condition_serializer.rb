# frozen_string_literal: true

class REST::FilterConditionSerializer < ActiveModel::Serializer
  attributes :id, :name, :value
end
