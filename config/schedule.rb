every :weekday, at: '0:05am' do
  rake 'action_points:daily_activity'
end

every :day, at: '0:05am' do
  rake 'employees:start_date'
end

every :day, at: '0:05am' do
  rake 'employees:one_month'
  rake 'employees:three_months'
end

every :monday, at: '0:05am' do
  #rake 'employees:one_on_one_meeting'
  #rake 'employees:performance_review'
end
