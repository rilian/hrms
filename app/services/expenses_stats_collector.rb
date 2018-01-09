class ExpensesStatsCollector
  attr_accessor :stats

  def initialize(person_id:)
    @person = Person.find(person_id)
    @stats = {}
  end

  def perform
    return true if @person.start_date.blank? || @person.start_date > Time.zone.now

    current_date = @person.start_date
    year = 0

    while !current_working_period(current_date - 1.year) && (@person.finish_date.present? ? current_date < @person.finish_date : true)
      period_expenses = @person
        .expenses
        .where('recorded_on >= ? AND recorded_on < ?', current_date.strftime("%F"), (current_date + 1.year - 1.day).strftime("%F"))

      item = {}
      item['year'] = year
      item['period_start_date'] = current_date.strftime("%e %b %Y").strip
      item['period_end_date'] = (current_date + 1.year - 1.day).strftime("%e %b %Y").strip
      item['period'] = "#{item['period_start_date']} - #{item['period_end_date']}"
      item['total_expenses'] = period_expenses.sum(:amount)
      item['total_expenses_by_type'] = {}
      Expense::TYPES.each do |type|
        item['total_expenses_by_type'][type] = period_expenses.where(type: type).sum(:amount)
      end

      item['remaining_expenses'] = [0, ENV['EXPENSES_LIMIT_PER_YEAR'].to_i - item['total_expenses']].max

      stats[year.to_s] = item

      year += 1
      current_date += 1.year
    end

    stats
  end

  private


  def current_working_period(date)
    date < Time.zone.now && date + 1.year >= Time.zone.now
  end
end
