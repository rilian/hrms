class AddIndexes8316 < ActiveRecord::Migration[4.2]
  def change
    add_index :taggings, [:taggable_id, :taggable_type, :tag_id]
    add_index :taggings, :tag_id
    add_index :people, :status
  end
end
