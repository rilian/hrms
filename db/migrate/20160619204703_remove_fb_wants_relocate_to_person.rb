class RemoveFbWantsRelocateToPerson < ActiveRecord::Migration
  def change
    remove_column :people, :facebook
    remove_column :people, :wants_relocate
  end
end
