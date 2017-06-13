class AddCurrentPositionToPerson < ActiveRecord::Migration
  def change
    add_column :people, :current_position, :string
  end
end
