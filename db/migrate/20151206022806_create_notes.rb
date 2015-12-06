class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :person, index: true
      t.string :type
      t.text :value
      t.timestamps null: false
    end
  end
end
