class AddEmployeeIdToPerson < ActiveRecord::Migration
  def change
    add_column :people, :employee_id, :string
  end
end
