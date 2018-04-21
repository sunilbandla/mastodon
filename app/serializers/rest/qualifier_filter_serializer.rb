# frozen_string_literal: true

class REST::QualifierFilterSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :filter_condition, serializer: REST::FilterConditionSerializer
  belongs_to :action_config, serializer: REST::ActionConfigSerializer

  def id
    object.id
  end

  def qualifier_consumer_id
    object.qualifier_consumer_id
  end

end
