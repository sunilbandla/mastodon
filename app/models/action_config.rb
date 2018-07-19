# frozen_string_literal: true

# == Schema Information
#
# Table name: action_configs
#
#  id              :bigint(8)        not null, primary key
#  action_type_id  :bigint(8)
#  folder_label_id :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ActionConfig < ApplicationRecord
  belongs_to :action_type
  belongs_to :folder_label, optional: true
  accepts_nested_attributes_for :folder_label, allow_destroy: true, reject_if: :new_record?

  delegate :id,
           to: :class,
           prefix: true,
           allow_nil: false

  def type
    ActionType.find(action_type_id)
  end

  def folder
    FolderLabel.find(folder_label_id)
  end
end
