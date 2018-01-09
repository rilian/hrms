module ReportsHelper
  def expenses_stats_per_year(person_id)
    service = ExpensesStatsCollector.new(person_id: person_id)
    service.perform
    service.stats
  end
end