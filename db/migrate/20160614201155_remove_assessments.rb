class RemoveAssessments < ActiveRecord::Migration[4.2]
  def change
    drop_table :assessments
  end
end
