class CleanupUpdatedByIdToAll < ActiveRecord::Migration[5.2]
  def change
    remove_column :action_points, :updated_by_id
    remove_column :attachments, :updated_by_id
    remove_column :dayoffs, :updated_by_id
    remove_column :expenses, :updated_by_id
    remove_column :notes, :updated_by_id
    remove_column :people, :updated_by_id
    remove_column :project_notes, :updated_by_id
    remove_column :projects, :updated_by_id
    remove_column :vacancies, :updated_by_id
    remove_column :users, :updated_by_id
  end
end
