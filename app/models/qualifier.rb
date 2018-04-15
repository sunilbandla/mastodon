# == Schema Information
#
# Table name: qualifiers
#
#  id                    :integer          not null, primary key
#  name                  :string
#  description           :text
#  qualifier_category_id :integer
#  endpoint              :string
#  price                 :decimal(5, 2)
#  version               :string
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Qualifier < ApplicationRecord
  belongs_to :qualifier_category
  belongs_to :user
end
