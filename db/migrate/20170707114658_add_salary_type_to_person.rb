class AddSalaryTypeToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :salary_type, :string
  end
end
