class AddProjectNotesCountToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :project_notes_count, :integer, default: 0
  end
end
