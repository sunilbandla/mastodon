# frozen_string_literal: true

class REST::ActionConfigSerializer < ActiveModel::Serializer
  attributes :id
  
  belongs_to :action_type, serializer: REST::ActionTypeSerializer
  belongs_to :folder_label, serializer: REST::FolderLabelSerializer

  def id
    object.id
  end

end
