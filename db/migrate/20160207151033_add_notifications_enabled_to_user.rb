class AddNotificationsEnabledToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :notifications_enabled, :boolean, default: true, null: false
  end
end
