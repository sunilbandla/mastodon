# frozen_string_literal: true

# == Schema Information
#
# Table name: qualifier_consumers
#
#  id           :bigint(8)        not null, primary key
#  account_id   :bigint(8)
#  qualifier_id :bigint(8)
#  enabled      :boolean
#  trial        :boolean
#  active       :boolean
#  payment_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class QualifierConsumer < ApplicationRecord
  belongs_to :account
  belongs_to :qualifier
  has_many :qualifier_filters
  accepts_nested_attributes_for :qualifier_filters, allow_destroy: true, reject_if: :new_record?

  delegate :id,
           :account_id,
           :qualifier_id,
           :enabled,
           :trial,
           :active,
           :payment_date,
           to: :class,
           prefix: true,
           allow_nil: false

  def qualifier
    Qualifier.find(qualifier_id)
  end
end
