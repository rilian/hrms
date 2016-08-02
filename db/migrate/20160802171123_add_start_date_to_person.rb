class AddStartDateToPerson < ActiveRecord::Migration
  def change
    add_column :people, :start_date, :date
  end
end
