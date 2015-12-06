class CreatePerson < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :city
      t.string :phone
      t.string :skype
      t.string :linkedin
      t.string :facebook
      t.string :wants_relocate
      t.string :primary_tech
      t.string :english
      t.date :day_of_birth
      t.timestamps null: false
    end
  end
end
