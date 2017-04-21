class CreateDayoffs < ActiveRecord::Migration[4.2]
  def change
    create_table :dayoffs do |t|
      t.references :person, index: true, null: false
      t.string :type
      t.text :notes
      t.integer :days, null: false, default: 1
      t.date :start_on
      t.date :end_on

      t.timestamps
    end
  end
end
