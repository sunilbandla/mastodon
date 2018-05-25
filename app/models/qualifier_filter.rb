# == Schema Information
#
# Table name: qualifier_filters
#
#  id                    :bigint(8)        not null, primary key
#  qualifier_consumer_id :bigint(8)
#  filter_condition_id   :bigint(8)
#  action_config_id      :bigint(8)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class QualifierFilter < ApplicationRecord
  belongs_to :qualifier_consumer
  belongs_to :filter_condition
  belongs_to :action_config
end
