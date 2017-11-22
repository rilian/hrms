class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :status, null: false, default: 'active'
      t.date :started_at
      t.datetime :updated_at
      t.integer :updated_by_id
      t.timestamps null: false
    end
  end
end
