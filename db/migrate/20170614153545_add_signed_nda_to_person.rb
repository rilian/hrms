class AddSignedNdaToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :signed_nda, :boolean, default: false, null: false
  end
end
