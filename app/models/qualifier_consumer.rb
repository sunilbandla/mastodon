# == Schema Information
#
# Table name: qualifier_consumers
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  qualifier_id :integer
#  enabled      :boolean
#  trial        :boolean
#  active       :boolean
#  payment_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class QualifierConsumer < ApplicationRecord
  belongs_to :user
  belongs_to :qualifier
end
