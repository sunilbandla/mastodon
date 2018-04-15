class CreateQualifierConsumers < ActiveRecord::Migration[5.2]
  def change
    create_table :qualifier_consumers do |t|
      t.references :user, foreign_key: true
      t.references :qualifier, foreign_key: true
      t.boolean :enabled
      t.boolean :trial
      t.boolean :active
      t.datetime :payment_date

      t.timestamps
    end
  end
end
