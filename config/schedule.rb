every :weekday, at: '0:05am' do
  rake 'action_points:daily_activity'
end
