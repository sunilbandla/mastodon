class RenameUserIdToAccountId < ActiveRecord::Migration[5.2]
  def change
    safety_assured { rename_column :folder_labels, :user_id, :account_id }
    safety_assured { rename_column :qualifier_consumers, :user_id, :account_id }
    safety_assured { rename_column :qualifiers, :user_id, :account_id }
  end
end
