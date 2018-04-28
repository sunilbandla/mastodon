# == Schema Information
#
# Table name: action_configs
#
#  id              :bigint(8)        not null, primary key
#  action_type_id  :bigint(8)
#  skipInbox       :boolean
#  folder_label_id :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ActionConfig < ApplicationRecord
  belongs_to :action_type
  belongs_to :folder_label
end
