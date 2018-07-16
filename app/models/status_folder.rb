# frozen_string_literal: true

# == Schema Information
#
# Table name: status_folders
#
#  id              :bigint(8)        not null, primary key
#  status_id       :bigint(8)
#  folder_label_id :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class StatusFolder < ApplicationRecord
  belongs_to :status
  belongs_to :folder_label
end
