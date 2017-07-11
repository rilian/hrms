every :weekday, at: '0:05am' do
  rake 'action_points:daily_activity'
end

every :day, at: '0:05am' do
  rake 'employees:start_date'
end
