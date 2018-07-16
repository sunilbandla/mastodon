# frozen_string_literal: true

class FolderFeed < Feed
  def initialize(folder)
    @type    = :folder
    @id      = folder.id
  end

  protected

  def key
    FolderManager.instance.key(nil, @id)
  end
end
