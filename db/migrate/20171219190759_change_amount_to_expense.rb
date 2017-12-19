class ChangeAmountToExpense < ActiveRecord::Migration[5.1]
  def change
  	change_column :expenses, :amount, :integer, default: nil, null: false
  end
end
