class CreateFilterConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :filter_conditions do |t|
      t.string :name
      t.boolean :value

      t.timestamps
    end
  end
end
