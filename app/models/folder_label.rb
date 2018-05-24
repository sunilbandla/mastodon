# == Schema Information
#
# Table name: folder_labels
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  account_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FolderLabel < ApplicationRecord
  belongs_to :account
end
