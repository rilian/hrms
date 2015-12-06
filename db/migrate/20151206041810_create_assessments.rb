class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.references :person, index: true, null: false
      t.jsonb :value, default: '{}', null: false
      t.timestamps null: false
    end
  end
end
