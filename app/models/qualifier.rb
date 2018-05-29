# == Schema Information
#
# Table name: qualifiers
#
#  id                    :bigint(8)        not null, primary key
#  name                  :string
#  description           :text
#  qualifier_category_id :bigint(8)
#  endpoint              :string
#  price                 :decimal(5, 2)
#  version               :string
#  account_id            :bigint(8)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Qualifier < ApplicationRecord
  belongs_to :qualifier_category
  belongs_to :account

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :endpoint, presence: true, length: { minimum: 10 }
  validates :price, presence: true
  validates :version, presence: true

  def category
    QualifierCategory.find(qualifier_category_id)
  end

  def account
    Account.find_by(id: account_id)
  end

end
