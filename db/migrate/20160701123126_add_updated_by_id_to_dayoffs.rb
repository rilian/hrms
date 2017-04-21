class AddUpdatedByIdToDayoffs < ActiveRecord::Migration[4.2]
  def change
    add_column :dayoffs, :updated_by_id, :integer
  end
end
