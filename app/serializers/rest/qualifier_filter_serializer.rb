# frozen_string_literal: true

class REST::QualifierFilterSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :filter_condition, serializer: REST::FilterConditionSerializer
  belongs_to :action_config, serializer: REST::ActionConfigSerializer
end
