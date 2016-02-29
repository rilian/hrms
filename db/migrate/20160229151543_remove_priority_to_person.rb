class RemovePriorityToPerson < ActiveRecord::Migration
  def change
    remove_column :people, :priority
  end
end
