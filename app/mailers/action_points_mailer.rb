class ActionPointsMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def daily_activity(user_id)
    @user = User.find(user_id)
    @time = Time.zone.now
    @action_points = ActionPoint
      .where(
        is_completed: false,
        perform_on: @time.midnight..(@time.midnight + 1.day)
      )

    mail(
      subject: "[HRMS] Actions digest for #{@time.strftime('%e %b %Y')}",
      to: @user.email
    )
  end
end
