# frozen_string_literal: true

class REST::FolderLabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :account_id

  def id
    object.id
  end

  def account_id
    object.account_id
  end

  def name
    object.name
  end

end
