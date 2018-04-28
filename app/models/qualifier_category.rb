# == Schema Information
#
# Table name: qualifier_categories
#
#  id         :bigint(8)        not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class QualifierCategory < ApplicationRecord
end
