class AddCountsToQualifier < ActiveRecord::Migration[5.2]
  def up
    add_column :qualifiers, :ratings_count, :decimal
    add_column :qualifiers, :ratings_avg, :decimal, precision: 5, scale: 2
  end
  def down
    remove_column :qualifiers, :ratings_count
    remove_column :qualifiers, :ratings_avg
  end
end
