class CreateDayoffs < ActiveRecord::Migration
  def change
    create_table :dayoffs do |t|
      t.references :person, index: true, null: false
      t.string :type
      t.text :notes
      t.integer :days, null: false, default: 0
      t.date :start_on
      t.date :end_on

      t.timestamps
    end
  end
end
