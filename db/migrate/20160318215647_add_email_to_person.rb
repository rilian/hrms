class AddEmailToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :email, :string
  end
end
