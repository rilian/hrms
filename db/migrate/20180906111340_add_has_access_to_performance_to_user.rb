class AddHasAccessToPerformanceToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :has_access_to_performance, :boolean, default: false
  end
end
