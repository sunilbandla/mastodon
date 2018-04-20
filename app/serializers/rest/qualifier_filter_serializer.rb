# frozen_string_literal: true

class REST::QualifierFilterSerializer < ActiveModel::Serializer
  attributes :id, :qualifier_consumer_id, :filter_condition_id, :action_config_id

  belongs_to :filter_condition
  belongs_to :action_config, serializer: REST::ActionConfigSerializer

  def id
    object.id
  end

  def qualifier_consumer_id
    object.qualifier_consumer_id
  end

  class FilterConditionSerializer < ActiveModel::Serializer
    attributes :name, :value
  end

end
