class Note < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = [
    'Initial Interview',
    'Skype Conversation',
    'Skype Call',
    'Phone Call',
    'Tech Interview',
    'Test Assignment',
    'Expected Salary',
    'Decision',
    'CEO Opinion',
    'Was Recommended',
    'Looking for Job',
    'Changed Job',
    'Other'
  ]

  belongs_to :person

  validates :type, :person, presence: true
  validates :type, inclusion: { in: TYPES }
end
