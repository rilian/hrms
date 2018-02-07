class AddEmployeeIdToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :employee_id, :string
  end
end
