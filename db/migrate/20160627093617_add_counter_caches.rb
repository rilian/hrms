class AddCounterCaches < ActiveRecord::Migration
  def change
    add_column :people, :action_points_count, :integer
    add_column :people, :attachments_count, :integer
    add_column :people, :notes_count, :integer
    add_index :people, :action_points_count
    add_index :people, :attachments_count
    add_index :people, :notes_count

    ActiveRecord::Base.connection.execute(
      'UPDATE people SET
       action_points_count=(SELECT COUNT(*) FROM action_points WHERE person_id=people.id),
       attachments_count=(SELECT COUNT(*) FROM attachments WHERE person_id=people.id),
       notes_count=(SELECT COUNT(*) FROM notes WHERE person_id=people.id)')
  end
end
