class CreateProjectNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :project_notes do |t|
      t.integer :project_id, null: false
      t.text :value
      t.integer :updated_by_id
      t.timestamps null: false
    end

    add_index :project_notes, :project_id
  end
end
