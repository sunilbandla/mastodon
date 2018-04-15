# == Schema Information
#
# Table name: qualifier_ratings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  qualifier_id :integer
#  value        :decimal(5, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class QualifierRating < ApplicationRecord
  belongs_to :user
  belongs_to :qualifier
end
