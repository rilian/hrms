class AddVacationOverrideToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :vacation_override, :integer
  end
end
