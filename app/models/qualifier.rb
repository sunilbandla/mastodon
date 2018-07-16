# frozen_string_literal: true

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
#  ratings_count         :decimal(, )
#  ratings_avg           :decimal(5, 2)
#  headers               :text
#

class Qualifier < ApplicationRecord
  belongs_to :qualifier_category
  belongs_to :account

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :endpoint, presence: true, length: { minimum: 10 }
  validates :price, presence: true
  validates :version, presence: true

  validates_with QualifierHeadersValidator

  default_scope { order('ratings_avg DESC NULLS LAST') }

  delegate :id,
           :name,
           :description,
           :endpoint,
           :price,
           :version,
           :qualifier_category_id,
           :account_id,
           to: :class,
           prefix: true,
           allow_nil: false

  def category
    QualifierCategory.find(qualifier_category_id)
  end

  def account
    Account.find_by(id: account_id)
  end

  def ratings
    QualifierRating.where(qualifier_id: id)
  end

  def update_ratings_avg
    @value = 0
    ratings.each do |rating|
      @value += rating.value
    end
    @total = ratings.size
    avg = if @total.positive?
            @value.to_f / @total.to_f
          else
            0
          end
    update_attribute(:ratings_avg, avg.round(2))
  end
end
