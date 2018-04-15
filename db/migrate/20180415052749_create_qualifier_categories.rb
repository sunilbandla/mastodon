class CreateQualifierCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :qualifier_categories do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
    add_index :qualifier_categories, :code, unique: true
  end
end
