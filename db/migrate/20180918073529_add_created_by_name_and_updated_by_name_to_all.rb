class AddCreatedByNameAndUpdatedByNameToAll < ActiveRecord::Migration[5.2]
  def change
    add_column :action_points, :updated_by_name, :string
    add_column :attachments, :updated_by_name, :string
    add_column :dayoffs, :updated_by_name, :string
    add_column :expenses, :updated_by_name, :string
    add_column :notes, :updated_by_name, :string
    add_column :people, :updated_by_name, :string
    add_column :project_notes, :updated_by_name, :string
    add_column :projects, :updated_by_name, :string
    add_column :users, :updated_by_name, :string

    add_column :action_points, :created_by_name, :string
    add_column :attachments, :created_by_name, :string
    add_column :dayoffs, :created_by_name, :string
    add_column :expenses, :created_by_name, :string
    add_column :notes, :created_by_name, :string
    add_column :people, :created_by_name, :string
    add_column :project_notes, :created_by_name, :string
    add_column :projects, :created_by_name, :string
    add_column :users, :created_by_name, :string

    %w(action_points attachments dayoffs expenses notes people project_notes projects users).each do |table|
      ActiveRecord::Base.connection.execute("
        UPDATE #{table} SET updated_by_name = (SELECT email FROM users WHERE users.id = #{table}.updated_by_id);
        UPDATE #{table} SET created_by_name = updated_by_name
      ")
    end
  end
end
