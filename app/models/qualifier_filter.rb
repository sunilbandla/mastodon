# == Schema Information
#
# Table name: qualifier_filters
#
#  id                    :integer          not null, primary key
#  qualifier_consumer_id :integer
#  filter_condition_id   :integer
#  action_config_id      :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class QualifierFilter < ApplicationRecord
  belongs_to :qualifier_consumer
  belongs_to :filter_condition
  belongs_to :action_config
end
