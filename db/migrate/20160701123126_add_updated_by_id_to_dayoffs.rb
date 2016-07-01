class AddUpdatedByIdToDayoffs < ActiveRecord::Migration
  def change
    add_column :dayoffs, :updated_by_id, :integer
  end
end
