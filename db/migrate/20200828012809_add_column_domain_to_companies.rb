class AddColumnDomainToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :domain, :string
    add_column :companies, :description, :string
  end
end
