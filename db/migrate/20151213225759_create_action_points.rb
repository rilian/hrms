class CreateActionPoints < ActiveRecord::Migration[4.2]
  def change
    create_table :action_points do |t|
      t.references :person, index: true, null: false
      t.text :value
      t.boolean :is_completed, default: false, null: false
      t.date :perform_on
      t.timestamps null: false
    end
  end
end
