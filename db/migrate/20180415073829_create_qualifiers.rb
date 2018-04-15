class CreateQualifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :qualifiers do |t|
      t.string :name
      t.text :description
      t.references :qualifier_category, foreign_key: true
      t.string :endpoint
      t.decimal :price, precision: 5, scale: 2
      t.string :version
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
