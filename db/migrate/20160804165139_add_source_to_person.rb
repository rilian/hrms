class AddSourceToPerson < ActiveRecord::Migration
  def change
    add_column :people, :source, :string
  end
end
