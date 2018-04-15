# == Schema Information
#
# Table name: folder_labels
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FolderLabel < ApplicationRecord
  belongs_to :user
end
