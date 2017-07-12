module DayoffsHelper
  def vacation_stats_per_year(person_id)
    service = VacationStatsCollector.new(person_id: person_id)
    service.perform
    service.stats
  end

  def months_worked(person)
    return 0 unless person.start_date
    ((person.finish_date || Date.today).year * 12 - person.start_date.year * 12) +
      (person.finish_date || Date.today).month - person.start_date.month
  end
end
