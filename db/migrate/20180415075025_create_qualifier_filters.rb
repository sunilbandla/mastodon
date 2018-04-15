class CreateQualifierFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :qualifier_filters do |t|
      t.references :qualifier_consumer, foreign_key: true
      t.references :filter_condition, foreign_key: true
      t.references :action_config, foreign_key: true

      t.timestamps
    end
  end
end
