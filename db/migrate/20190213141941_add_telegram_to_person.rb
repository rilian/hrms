class AddTelegramToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :telegram, :string
  end
end
