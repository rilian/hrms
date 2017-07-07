class AddSalaryTypeToPerson < ActiveRecord::Migration
  def change
    add_column :people, :salary_type, :string
  end
end
