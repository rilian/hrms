class HiddenStatusesForUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :hide_tags, :string, array: true, default: []
    add_column :users, :hide_statuses, :string, array: true, default: []
  end
end
