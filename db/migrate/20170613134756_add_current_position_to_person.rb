class AddCurrentPositionToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :current_position, :string
  end
end
