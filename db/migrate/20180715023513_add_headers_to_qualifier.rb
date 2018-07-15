class AddHeadersToQualifier < ActiveRecord::Migration[5.2]
  def change
    add_column :qualifiers, :headers, :text
  end
end
