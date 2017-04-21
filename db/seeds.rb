p = Person.where(name: 'Vasiliy Pupkin', primary_tech: 'Ruby').first_or_create!
Note.where(person: p, type: 'Decision', value: 'Passed all interviews').first_or_create!
Note.where(person: p, type: 'Other', value: 'Great developer').first_or_create!
ActionPoint.where(person: p, value: 'Meet in a cafe', perform_on: Date.tomorrow).first_or_create!
ActionPoint.where(person: p, value: 'Hire', perform_on: Date.tomorrow).first_or_create!
User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = '12345678'
  u.has_access_to_users = true
  u.has_access_to_events = true
  u.has_access_to_finances= true
end

