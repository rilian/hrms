class CreateVacancies < ActiveRecord::Migration[4.2]
  def change
    create_table :vacancies do |t|
      t.string :project
      t.string :role
      t.text :description
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
