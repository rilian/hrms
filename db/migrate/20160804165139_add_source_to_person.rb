class AddSourceToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :source, :string
  end
end
