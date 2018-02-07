class AddUpdatedByToEntities < ActiveRecord::Migration[4.2]
  def change
    add_column :action_points, :updated_by_id, :integer
    add_column :assessments, :updated_by_id, :integer
    add_column :attachments, :updated_by_id, :integer
    add_column :notes, :updated_by_id, :integer
    add_column :people, :updated_by_id, :integer
    add_column :users, :updated_by_id, :integer
  end
end
