class RemovePriorityToPerson < ActiveRecord::Migration[4.2]
  def change
    remove_column :people, :priority
  end
end
