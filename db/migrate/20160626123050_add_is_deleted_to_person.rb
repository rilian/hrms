class AddIsDeletedToPerson < ActiveRecord::Migration
  def change
    add_column :people, :is_deleted, :boolean, default: false, null: false
    add_index :people, :is_deleted
  end
end
