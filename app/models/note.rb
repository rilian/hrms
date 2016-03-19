class Note < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = [
    'Email',
    'LinkedIn Message',
    'Initial Interview',
    'Initial Interview - Office',
    'Skype Conversation',
    'Skype Call',
    'Phone Call',
    'Tech Interview',
    'Tech Interview - Office',
    'Additional Interview',
    'Additional Interview - Office',
    'Test Assignment',
    'Expected Salary',
    'Decision',
    'CEO Opinion',
    'Interview With CEO',
    'Recommended',
    'Looking for Job',
    'Changed Job',
    'Other'
  ]

  belongs_to :person

  validates :type, :person, presence: true
  validates :type, inclusion: { in: TYPES }
end
