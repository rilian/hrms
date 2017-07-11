namespace :action_points do
  desc 'Sends action points activity for the day'
  task daily_activity: :environment do
    if ActionPoint.where(is_completed: false, perform_on: @time.midnight..(@time.midnight + 23.hours + 59.minutes)).exists?
      User.where(notifications_enabled: true).pluck(:id).each do |id|
        ActionPointsMailer.daily_activity(id).deliver_now
      end
    end
  end
end
