class CreateQualifierRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :qualifier_ratings do |t|
      t.references :user, foreign_key: true
      t.references :qualifier, foreign_key: true
      t.decimal :value, precision: 5, scale: 2

      t.timestamps
    end
  end
end
