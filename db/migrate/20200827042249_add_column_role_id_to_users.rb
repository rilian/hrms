class AddColumnRoleIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role_id, :integer, index: true
  end
end
