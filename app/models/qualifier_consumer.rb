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
end
