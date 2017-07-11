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
end
