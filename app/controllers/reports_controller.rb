class ReportsController < ApplicationController
  def index
  end

  def by_status
  end

  def people_with_similar_name
    @people = []
    previous_ids = []
    Person.not_deleted.accessible_by(current_ability).find_each(batch_size: 50) do |person|
      similars = Person.not_deleted.accessible_by(current_ability)
        .where('id NOT IN (?)', [person.id] + previous_ids)
        .where("(lower(name) ILIKE ?)
          OR (email IS NOT NULL AND email != '' AND email ILIKE ?)
          OR (phone IS NOT NULL AND phone != '' AND phone ILIKE ?)
          OR (skype IS NOT NULL AND skype != '' AND skype ILIKE ?)
          OR (linkedin IS NOT NULL AND linkedin != '' AND linkedin ILIKE ?)",
          "%#{person.name&.downcase&.strip}%",
          "%#{person.email&.strip&.presence || '#invalid#'}%",
          "%#{person.phone&.strip&.presence || '#invalid#'}%",
          "%#{person.skype&.strip&.presence || '#invalid#'}%",
          "%#{person.linkedin&.strip&.presence || '#invalid#'}%")

      if similars.exists?
        @people << {
          person: person,
          similars: similars
        }
        previous_ids += (similars.pluck(:id) + [person.id])
      end
    end
  end

  def historical_data
    @data = HistoricalDataCollector.new.perform
  end

  def employees
    @people = Person.not_deleted.accessible_by(current_ability)
                .where(status: Person::EMPLOYEE_STATUSES)
  end
end
