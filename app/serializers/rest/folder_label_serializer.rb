# frozen_string_literal: true

class REST::FolderLabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :account_id
end
