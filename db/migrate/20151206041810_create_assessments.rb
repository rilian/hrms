class CreateAssessments < ActiveRecord::Migration[4.2]
  def change
    create_table :assessments do |t|
      t.references :person, index: true, null: false
      t.jsonb :value, default: '{}', null: false
      t.integer :total, default: 0, null: false
      t.timestamps null: false
    end
  end
end
