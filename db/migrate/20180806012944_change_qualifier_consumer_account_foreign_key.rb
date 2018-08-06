class ChangeQualifierConsumerAccountForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :qualifier_consumers, column: :account_id
    add_foreign_key :qualifier_consumers, :accounts, column: :account_id
  end
end
