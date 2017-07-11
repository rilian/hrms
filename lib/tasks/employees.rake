namespace :employees do
  desc 'Sends advance notification about new employees first day'
  task start_date: :environment do
    employees = Person.not_deleted.accessible_by(current_ability).current_employee

    employees.where('start_date >= ? AND start_date < ?', 7.days.since.strftime('%F'), 8.days.since.strftime('%F')).each do |person|
      User.where(notifications_enabled: true).pluck(:id).each do |user_id|
        EmployeesMailer.start_date(user_id, person.id).deliver_now
      end
    end

    # if today is friday
    if Time.zone.now.strftime('%w') == '5'
      employees.where('start_date >= ? AND start_date < ?', 3.days.since.strftime('%F'), 4.days.since.strftime('%F')).each do |person|
        User.where(notifications_enabled: true).pluck(:id).each do |user_id|
          EmployeesMailer.start_date(user_id, person.id).deliver_now
        end
      end
    else
      employees.where('start_date >= ? AND start_date < ?', 1.days.since.strftime('%F'), 2.days.since.strftime('%F')).each do |person|
        User.where(notifications_enabled: true).pluck(:id).each do |user_id|
          EmployeesMailer.start_date(user_id, person.id).deliver_now
        end
      end
    end
  end
end
