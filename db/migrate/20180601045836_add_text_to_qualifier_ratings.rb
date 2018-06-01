class AddTextToQualifierRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :qualifier_ratings, :text, :string
    safety_assured { rename_column :qualifier_ratings, :user_id, :account_id }
  end
end
