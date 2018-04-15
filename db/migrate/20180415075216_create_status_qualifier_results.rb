class CreateStatusQualifierResults < ActiveRecord::Migration[5.2]
  def change
    create_table :status_qualifier_results do |t|
      t.references :status, foreign_key: true
      t.references :qualifier, foreign_key: true
      t.boolean :result

      t.timestamps
    end
  end
end
