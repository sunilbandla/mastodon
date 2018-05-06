class CreateStatusFolders < ActiveRecord::Migration[5.2]
  def change
    create_table :status_folders do |t|
      t.references :status, foreign_key: true
      t.references :folder_label, foreign_key: true

      t.timestamps
    end
  end
end
