class RemoveSkipInboxFromActionConfigs < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :action_configs, :skipInbox, :boolean }
  end
end
