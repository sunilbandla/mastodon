class CreateActionConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :action_configs do |t|
      t.references :action_type, foreign_key: true
      t.boolean :skipInbox
      t.references :folder_label, foreign_key: true

      t.timestamps
    end
  end
end
