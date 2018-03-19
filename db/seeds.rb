p1 = Person.create(name: 'Vasiliy Pupkin', primary_tech: 'Ruby')
n1 = Note.create(person: p1, type: 'Waiting for decision', value: 'Passed all interviews')
n2 = Note.create(person: p1, type: 'Other', value: 'Great developer')
ap1 = ActionPoint.create(person: p1, value: 'Meet in a cafe', perform_on: Date.tomorrow)
ap2 = ActionPoint.create(person: p1, value: 'Hire', perform_on: Date.tomorrow)
u = User.create(
  email: 'admin@example.com',
  password: '12345678',
  has_access_to_users: true,
  has_access_to_events: true,
  has_access_to_finances: true,
  has_access_to_dayoffs: true,
  has_access_to_expenses: true
)
