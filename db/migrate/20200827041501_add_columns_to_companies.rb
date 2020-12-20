class AddColumnsToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :logo_id, :string
    add_column :companies, :logo_filename, :string
    add_column :companies, :logo_size, :integer
    add_column :companies, :logo_content_type, :string
    add_column :companies, :favicon_id, :string
    add_column :companies, :favicon_filename, :string
    add_column :companies, :favicon_size, :integer
    add_column :companies, :favicon_content_type, :string
  end
end
