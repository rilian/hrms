class AddRoleToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :role, :string, default: 'admin', null: false
  end
end
