class CreateActionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :action_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    add_index :action_types, :code, unique: true
  end
end
