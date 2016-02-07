class AddNotificationsEnabledToUser < ActiveRecord::Migration
  def change
    add_column :users, :notifications_enabled, :boolean, default: true, null: false
  end
end
