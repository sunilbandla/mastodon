# == Schema Information
#
# Table name: qualifier_ratings
#
#  id           :bigint(8)        not null, primary key
#  account_id   :bigint(8)
#  qualifier_id :bigint(8)
#  value        :decimal(5, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  text         :string
#

class QualifierRating < ApplicationRecord
  belongs_to :account
  belongs_to :qualifier

  validates :text, presence: true, length: { minimum: 3 }

  def account
    Account.find_by(id: account_id)
  end

end
