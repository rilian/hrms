class RemoveAssessments < ActiveRecord::Migration
  def change
    drop_table :assessments
  end
end
