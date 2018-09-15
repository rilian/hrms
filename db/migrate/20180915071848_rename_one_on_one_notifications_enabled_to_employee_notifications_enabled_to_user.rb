class RenameOneOnOneNotificationsEnabledToEmployeeNotificationsEnabledToUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :one_on_one_notifications_enabled, :employee_notifications_enabled
  end
end
