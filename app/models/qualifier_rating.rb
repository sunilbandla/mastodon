# frozen_string_literal: true

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
  validates :value, presence: true

  after_create  :increment_counter_caches
  after_destroy :decrement_counter_caches

  def account
    Account.find_by(id: account_id)
  end

  def decrement_counter_caches
    Qualifier.where(id: qualifier_id).update_all('ratings_count = COALESCE(ratings_count, 0) - 1')
    qualifier.update_ratings_avg
  end

  def increment_counter_caches
    Qualifier.where(id: qualifier_id).update_all('ratings_count = COALESCE(ratings_count, 0) + 1')
    qualifier.update_ratings_avg
  end
end
