class AddContractorInfoToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :contractor_company_name, :string
    add_column :people, :contractor_manager_contacts, :text
  end
end
