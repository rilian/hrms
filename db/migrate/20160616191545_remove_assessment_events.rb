class RemoveAssessmentEvents < ActiveRecord::Migration[4.2]
  def change
    ActiveRecord::Base.connection.execute "DELETE FROM events WHERE entity_type='Assessment'"
  end
end
