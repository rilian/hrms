class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.references :person, index: true, null: false
      t.string :type, default: 'Other', null: false
      t.text :notes, default: '', null: false
      t.integer :amount, default: 0, null: false
      t.date :recorded_on
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
