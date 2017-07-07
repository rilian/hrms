class RemoveCulturalFitToPerson < ActiveRecord::Migration
  def change
    remove_column :people, :cultural_fit
  end
end
