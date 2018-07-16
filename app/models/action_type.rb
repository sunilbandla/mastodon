# frozen_string_literal: true

# == Schema Information
#
# Table name: action_types
#
#  id         :bigint(8)        not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ActionType < ApplicationRecord
end
