class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :entity_type, null: false
      t.integer :entity_id, null: false
      t.jsonb :params, default: '{}', null: false
      t.string :action, default: '', null: false
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :events, :params, using: 'gin'
    add_index :events, :user_id
    add_index :events, :entity_type
    add_index :events, :entity_id
  end
end
