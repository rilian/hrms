class AddMoreHasAccessVarsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :has_access_to_expenses, :boolean, default: false
    add_column :users, :has_access_to_dayoffs, :boolean, default: false
  end
end
