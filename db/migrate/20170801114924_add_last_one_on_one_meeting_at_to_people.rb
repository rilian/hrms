class AddLastOneOnOneMeetingAtToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :last_one_on_one_meeting_at, :date
  end
end
