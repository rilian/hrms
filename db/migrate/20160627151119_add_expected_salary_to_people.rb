class AddExpectedSalaryToPeople < ActiveRecord::Migration
  def change
    add_column :people, :expected_salary, :string

    Note.where(type: 'Expected Salary').delete_all
  end
end
