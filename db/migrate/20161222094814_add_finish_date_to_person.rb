class AddFinishDateToPerson < ActiveRecord::Migration
  def change
    add_column :people, :finish_date, :date
  end
end
