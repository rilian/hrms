class AddPhotoAndSkillsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :photo_id, :string
    add_column :people, :photo_filename, :string
    add_column :people, :photo_size, :integer
    add_column :people, :photo_content_type, :string
    add_column :people, :skills, :text
  end
end
