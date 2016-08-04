class ReportsController < ApplicationController
  def index
  end

  def by_status
  end

  def people_with_similar_name
    @people = []
    previous_ids = []
    Person.not_deleted.accessible_by(current_ability).each do |person|
      similars = Person.not_deleted.accessible_by(current_ability)
                  .where('id NOT IN (?)', [person.id] + previous_ids)
                  .where('lower(name) = ?', person.name.downcase)

      if similars.exists?
        @people << {
          person: person,
          similars: similars
        }
        previous_ids += (similars.pluck(:id) + [person.id])
      end
    end
  end
end
