module DayoffsHelper
  def allowed_vacation(person)
    return 0 unless person.start_date
    allowed = (((Date.today - person.start_date).to_i.abs) / 365.25 * ENV['VACATION_PER_YEAR'].to_i).ceil
    [allowed, ENV['VACATION_PER_YEAR'].to_i].max
  end

  def used_vacation(person)
    person.dayoffs.where(type: Dayoff::PAID_VACATION_TYPES).sum(:days)
  end

  def sick_leaves(person)
    person.dayoffs.where(type: 'Sick Leave').sum(:days)
  end

  def unpaid_days_off(person)
    person.dayoffs.where(type: 'Unpaid Day Off').sum(:days)
  end

  def months_worked(person)
    return 0 unless person.start_date
    (Date.today.year * 12 + Date.today.month) - (person.start_date.year * 12 + person.start_date.month)
  end
end
