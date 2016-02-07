namespace :action_points do
  desc 'Sends action points activity for the day'
  task daily_activity: :environment do
    User.where(notifications_enabled: true).pluck(:id).each do |id|
      ActionPointsMailer.daily_activity(id).deliver_now
    end
  end
end
