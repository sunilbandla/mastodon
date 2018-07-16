# frozen_string_literal: true

# == Schema Information
#
# Table name: status_qualifier_results
#
#  id           :bigint(8)        not null, primary key
#  status_id    :bigint(8)
#  qualifier_id :bigint(8)
#  result       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class StatusQualifierResult < ApplicationRecord
  belongs_to :status
  belongs_to :qualifier
end
