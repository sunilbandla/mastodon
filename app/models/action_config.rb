# == Schema Information
#
# Table name: action_configs
#
#  id              :integer          not null, primary key
#  action_type_id  :integer
#  skipInbox       :boolean
#  folder_label_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ActionConfig < ApplicationRecord
  belongs_to :action_type
  belongs_to :folder_label
end
