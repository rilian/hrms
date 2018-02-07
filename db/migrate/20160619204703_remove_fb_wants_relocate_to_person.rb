class RemoveFbWantsRelocateToPerson < ActiveRecord::Migration[4.2]
  def change
    remove_column :people, :facebook
    remove_column :people, :wants_relocate
  end
end
