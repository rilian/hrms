class AddOneOnOneNotificationsEnabledToUser < ActiveRecord::Migration
  def change
    add_column :users, :one_on_one_notifications_enabled, :boolean, default: false
  end
end
