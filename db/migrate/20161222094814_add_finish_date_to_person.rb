class AddFinishDateToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :finish_date, :date
  end
end
