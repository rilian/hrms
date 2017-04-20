class AddBoolRolesToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :has_access_to_finances, :boolean, default: false
    add_column :users, :has_access_to_events, :boolean, default: false
    add_column :users, :has_access_to_users, :boolean, default: false
    remove_column :users, :role, :string
  end
end
