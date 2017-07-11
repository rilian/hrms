module DayoffsHelper
  def allowed_vacation(person)
    return 0 unless person.start_date
    vacation_per_year = person.vacation_override.to_i > 0 ? person.vacation_override : ENV['VACATION_PER_YEAR'].to_i
    ((((person.finish_date || Date.today) - person.start_date).to_i.abs) / 365.25).ceil * vacation_per_year
  end

  def vacation_stats_per_year(person)
    return {} unless person.start_date

    stats = {}
    current_date = person.start_date
    year = 0

    while !current_working_period(current_date - 1.year) && (person.finish_date.present? ? current_date < person.finish_date : true)
      period_dayoffs = person
        .dayoffs
        .where('start_on >= ? AND start_on < ?', current_date.strftime(t(:for_csv)), (current_date + 1.year - 1.day).strftime(t(:for_csv)))

      item = {}
      item['year'] = year
      item['period_start_date'] = current_date.strftime(t(:day)).strip
      item['period_end_date'] = (current_date + 1.year - 1.day).strftime(t(:day)).strip
      item['period'] = "#{item['period_start_date']} - #{item['period_end_date']}"
      item['yearly_vacation_days_assigned'] = (person.vacation_override.to_i > 0 ? person.vacation_override : vacation_size(current_date, year).to_i)
      item['total_vacation_days'] = item['yearly_vacation_days_assigned'] + (stats.values.last.present? ? stats.values.last['transfer_days'] : 0)

      item['used_vacation'] = period_dayoffs.where(type: 'Vacation').sum(:days)
      item['overtime_days'] = period_dayoffs.where(type: 'Overtime').sum(:days)
      item['sick_leave_days'] = period_dayoffs.where(type: 'Sick Leave').sum(:days)
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

    puts stats
    stats
  end

  def used_vacation(person)
    person.dayoffs.where(type: 'Vacation').sum(:days)
  end

  def overtime_days(person)
    person.dayoffs.where(type: 'Overtime').sum(:days)
  end

  def sick_leaves(person)
    person.dayoffs.where(type: 'Sick Leave').sum(:days)
  end

  def unpaid_days_off(person)
    person.dayoffs.where(type: 'Unpaid Day Off').sum(:days)
  end

  def paid_days_off(person)
    person.dayoffs.where(type: 'Paid Day Off').sum(:days)
  end

  def working_days_shifts(person)
    person.dayoffs.where(type: 'Working Day Shift').sum(:days)
  end

  def months_worked(person)
    return 0 unless person.start_date
    ((person.finish_date || Date.today).year * 12 - person.start_date.year * 12) +
      (person.finish_date || Date.today).month - person.start_date.month
  end

  def remaining_vacation(person)
    (allowed_vacation(person) + overtime_days(person) - used_vacation(person)).ceil
  end

  def end_of_current_year(person)
    person.start_date +
      (Time.zone.now.year - person.start_date.year + (Time.zone.now.yday < person.start_date.yday ? 0 : 1)).years
  end

  private

  def vacation_size(date, year)
    if date < Time.strptime(ENV['PROGRESSIVE_VACATION_SIZE_START_DATE'], '%m/%d/%Y')
      ENV['VACATION_PER_YEAR'].to_i
    else
      VACATION_PER_YEAR_SIZE[year.to_s].presence || VACATION_PER_YEAR_SIZE.values.last
    end
  end

  def current_working_period(date)
    date < Time.zone.now && date + 1.year >= Time.zone.now
  end
end
