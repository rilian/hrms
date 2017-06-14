class AddSignedNdaToPerson < ActiveRecord::Migration
  def change
    add_column :people, :signed_nda, :boolean, default: false, null: false
  end
end
