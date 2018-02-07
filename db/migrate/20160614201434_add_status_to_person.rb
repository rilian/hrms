class AddStatusToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :status, :string
  end
end
