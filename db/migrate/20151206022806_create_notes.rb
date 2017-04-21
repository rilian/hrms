class CreateNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :notes do |t|
      t.references :person, index: true, null: false
      t.string :type, null: false, default: 'Other'
      t.text :value
      t.timestamps null: false
    end
  end
end
