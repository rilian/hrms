class ActionPointsMailer < ActionMailer::Base
  add_template_helper ApplicationHelper

  def daily_activity(user_id)
    @time = Time.zone.now
    @user = User.find(user_id)
    @action_points = ActionPoint.where(is_completed: false) # TODO: load only one date

    mail(
      subject: "[HRMS] Actions digest for #{@time.strftime('%e %b %Y')}",
      to: @user.email
    )
  end
end
