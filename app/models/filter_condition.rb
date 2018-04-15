# == Schema Information
#
# Table name: filter_conditions
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FilterCondition < ApplicationRecord
end
