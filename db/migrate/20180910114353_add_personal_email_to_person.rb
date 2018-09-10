class AddPersonalEmailToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :personal_email, :string
  end
end
