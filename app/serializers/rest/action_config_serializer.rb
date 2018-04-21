# frozen_string_literal: true

class REST::ActionConfigSerializer < ActiveModel::Serializer
  attributes :id, :skipInbox
  
  belongs_to :action_type, serializer: REST::ActionTypeSerializer
  belongs_to :folder_label, serializer: REST::FolderLabelSerializer

  def id
    object.id
  end

  def skipInbox
    object.skipInbox
  end

end
