class VacationStatsCollector
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
      period_dayoffs = @person
        .dayoffs
        .where('start_on >= ? AND start_on < ?', current_date.strftime("%F"), (current_date + 1.year - 1.day).strftime("%F"))

      item = {}
      item['year'] = year
      item['period_start_date'] = current_date.strftime("%e %b %Y").strip
      item['period_end_date'] = (current_date + 1.year - 1.day).strftime("%e %b %Y").strip
      item['period'] = "#{item['period_start_date']} - #{item['period_end_date']}"
      item['yearly_vacation_days_assigned'] = [@person.vacation_override.to_i, vacation_size(current_date, year).to_i].max
      item['total_vacation_days'] = item['yearly_vacation_days_assigned'] + (stats.values.last.present? ? stats.values.last['transfer_days'] : 0)

      item['used_vacation'] = period_dayoffs.where(type: 'Vacation').sum(:days)
      item['overtime_days'] = period_dayoffs.where(type: 'Overtime').sum(:days)
      item['sick_leave_days'] = period_dayoffs.where(type: 'Sick Leave').sum(:days)
      item['remaining_sick_leave_days'] = (ENV['SICK_LEAVE_DAYS_PER_YEAR'] || 0) - item['sick_leave_days']
      item['unpaid_days_off'] = period_dayoffs.where(type: 'Unpaid Day Off').sum(:days)
      item['paid_days_off'] = period_dayoffs.where(type: 'Paid Day Off').sum(:days)
      item['working_days_shifts'] = period_dayoffs.where(type: 'Working Day Shift').sum(:days)

      item['remaining_vacation'] = (item['total_vacation_days'] + item['overtime_days'] - item['used_vacation'])

      # do not burn before certain date
      item['burn_days'] =
        if current_date < Time.strptime(ENV['PROGRESSIVE_VACATION_SIZE_START_DATE'], '%m/%d/%Y')
          0
        else
          [item['remaining_vacation'] - [item['remaining_vacation'], VACATION_MAX_END_OF_YEAR_TRANSFER].min, 0].max
        end
      item['transfer_days'] = item['remaining_vacation'] - item['burn_days']

      stats[year.to_s] = item

      year += 1
      current_date += 1.year
    end

    stats
  end

  private

  def vacation_size(date, year)
    if date < Time.strptime(ENV['PROGRESSIVE_VACATION_SIZE_START_DATE'], '%m/%d/%Y')
      ENV['VACATION_PER_YEAR'].to_i
    elsif date < Time.strptime(ENV['PROGRESSIVE_VACATION_SIZE_START_DATE_2'], '%m/%d/%Y')
      VACATION_PER_YEAR_SIZE[year.to_s].presence || VACATION_PER_YEAR_SIZE.values.last
    else
      VACATION_PER_YEAR_SIZE_2[year.to_s].presence || VACATION_PER_YEAR_SIZE_2.values.last
    end
  end

  def current_working_period(date)
    date < Time.zone.now && date + 1.year >= Time.zone.now
  end
end
