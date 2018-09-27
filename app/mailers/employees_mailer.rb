class EmployeesMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def start_date(user_id, person_id)
    @user = User.find(user_id)
    @person = Person.find(person_id)

    mail(
      subject: "[HRMS] New employee #{@person.name} starts work on #{@person.start_date.strftime('%a, %e %b')}",
      to: @user.email
    )
  end

  def one_on_one(user_id, employees)
    @user = User.find(user_id)
    @employees = employees

    mail(
      subject: "[HRMS] 1-1 meeting plan for the week #{Time.zone.now.beginning_of_week.strftime('%a, %e %b')} - #{(Time.zone.now.beginning_of_week + 4.days).strftime('%a, %e %b')}",
      to: @user.email
    )
  end

  def performance_review(user_id, employees)
    @user = User.find(user_id)
    @employees = employees

    mail(
      subject: "[HRMS] Performance review plan for the week #{Time.zone.now.beginning_of_week.strftime('%a, %e %b')} - #{(Time.zone.now.beginning_of_week + 4.days).strftime('%a, %e %b')}",
      to: @user.email
    )
  end

  def n_months(user_id, employees, months)
    @user = User.find(user_id)
    @employees = employees
    @months = months
    mail subject: "[HRMS] Employees worked for #{@months} #{ActionView::Helpers::TextHelper.pluralize(@months, 'month')} already", to: @user.email
  end
end
