class AddStatusToPerson < ActiveRecord::Migration
  def change
    add_column :people, :status, :string
  end
end
