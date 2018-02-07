class RemoveCulturalFitToPerson < ActiveRecord::Migration[4.2]
  def change
    remove_column :people, :cultural_fit
  end
end
