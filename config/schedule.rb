every :weekday, at: '5:00am' do
  rake 'action_points:daily_activity'
end
