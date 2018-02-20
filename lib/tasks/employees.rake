namespace :employees do
  desc 'Sends advance notification about new employees first day'
  task start_date: :environment do
    ids = []
    employees = Person.not_deleted.where(status: ['Hired', 'Contractor'])

    # who comes 1st day in 1 week
    ids += employees
      .where('start_date >= ? AND start_date < ?', 7.days.since.strftime('%F'), 8.days.since.strftime('%F'))
      .pluck(:id)

    # who was created yesterday and comes 1st day in 1 week
    ids += employees
      .where('created_at >= ? AND start_date < ?', 1.day.ago.strftime('%F'), 8.days.since.strftime('%F'))
      .where('start_date >= ? AND start_date < ?', Time.zone.now.strftime('%F'), 8.days.since.strftime('%F'))
      .pluck(:id)

    # if today is friday and comes 1st day on monday
    if Time.zone.now.strftime('%w') == '5'
      ids += employees
        .where('start_date >= ? AND start_date < ?', 3.days.since.strftime('%F'), 4.days.since.strftime('%F'))
        .pluck(:id)
    else
      # comes 1st day tomorrow
      ids += employees
        .where('start_date >= ? AND start_date < ?', 1.days.since.strftime('%F'), 2.days.since.strftime('%F'))
        .pluck(:id)
    end

    User.where(notifications_enabled: true).pluck(:id).each do |user_id|
      ids.uniq.each do |person_id|
        EmployeesMailer.start_date(user_id, person_id).deliver_now
      end
    end
  end

  desc 'Sends advance notification about 1-1 meetings'
  task one_on_one_meeting: :environment do
    employees = Person.not_deleted.current_employee
      .where('city ILIKE ?', ENV['MAIN_CITY'])
      .where('start_date < ?', 3.months.ago.strftime('%F'))
      .where('last_one_on_one_meeting_at IS NULL OR last_one_on_one_meeting_at < ?', 3.months.ago.strftime('%F'))
      .reorder('last_one_on_one_meeting_at IS NOT NULL, last_one_on_one_meeting_at ASC')
      .order(:name)

    User.where(one_on_one_notifications_enabled: true).pluck(:id).each do |user_id|
      EmployeesMailer.one_on_one(user_id, employees).deliver_now
    end
  end
end
