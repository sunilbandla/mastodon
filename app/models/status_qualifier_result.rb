# == Schema Information
#
# Table name: status_qualifier_results
#
#  id           :integer          not null, primary key
#  status_id    :integer
#  qualifier_id :integer
#  result       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class StatusQualifierResult < ApplicationRecord
  belongs_to :status
  belongs_to :qualifier
end
