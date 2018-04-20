# frozen_string_literal: true

class REST::ActionConfigSerializer < ActiveModel::Serializer
  attributes :id, :skipInbox
  
  belongs_to :action_type
  belongs_to :folder_label

  def id
    object.id
  end

  def skipInbox
    object.skipInbox
  end

  class ActionTypeSerializer < ActiveModel::Serializer
    attributes :name, :code
  end

  class FolderLabelSerializer < ActiveModel::Serializer
    attributes :name
  end

end
