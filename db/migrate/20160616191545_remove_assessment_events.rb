class RemoveAssessmentEvents < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute "DELETE FROM events WHERE entity_type='Assessment'"
  end
end
