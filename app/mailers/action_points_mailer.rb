class ActionPointsMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def daily_activity(user_id)
    @user = User.find(user_id)
    @time = Time.zone.now
    @action_points = ActionPoint
      .where(
        is_completed: false,
        perform_on: @time.midnight..(@time.midnight + 23.hours + 59.minutes)
      )

    mail(
      subject: "[HRMS] Actions digest for #{@time.strftime(t(:datetime_short))}",
      to: @user.email
    )
  end
end
