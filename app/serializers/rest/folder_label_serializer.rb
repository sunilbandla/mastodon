# frozen_string_literal: true

class REST::FolderLabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id

  def id
    object.id
  end

  def user_id
    object.user_id
  end

  def name
    object.name
  end

end
