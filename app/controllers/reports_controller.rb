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
                  .where('lower(name) ILIKE ?', "%#{person.name.downcase}%")

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
end
