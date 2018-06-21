module PeopleHelper
  def hr_status_updates(person_id)
    r = Event.where(action: %w(person.updated person.created), entity_id: person_id, entity_type: 'Person')
         .order(created_at: :desc).map do |event|
      next if event.params['status'].blank?
      [event.params['status'], event.created_at]
    end.compact
  end
end
