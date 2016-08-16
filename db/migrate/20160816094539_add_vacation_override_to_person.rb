class AddVacationOverrideToPerson < ActiveRecord::Migration
  def change
    add_column :people, :vacation_override, :integer
  end
end
