# == Schema Information
#
# Table name: qualifier_ratings
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)
#  qualifier_id :bigint(8)
#  value        :decimal(5, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class QualifierRating < ApplicationRecord
  # TODO update to belongs_to :account
  belongs_to :user
  belongs_to :qualifier
end
