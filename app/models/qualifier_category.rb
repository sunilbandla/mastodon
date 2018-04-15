# == Schema Information
#
# Table name: qualifier_categories
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class QualifierCategory < ApplicationRecord
end
