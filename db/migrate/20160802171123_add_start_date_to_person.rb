class AddStartDateToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :start_date, :date
  end
end
