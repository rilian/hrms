class Note < ActiveRecord::Base
  include ChangesTracker

  self.inheritance_column = nil

  TYPE_SALARY = 'Salary'
  TYPE_PERFORMANCE_REVIEW = 'Performance Review'
  TYPE_EXIT_INTERVIEW = 'Exit Interview'
  TYPES = [
    "Recruiter's Note",
    'CV Review',
    'Message From Candidate',
    'Conversation / Call',
    'Initial Interview',
    'Tech Interview',
    'Additional Interview',
    'Test Assignment',
    'CEO Opinion',
    'Decision',
    'Recommended',
    TYPE_SALARY,
    "Manager's Note",
    TYPE_PERFORMANCE_REVIEW,
    TYPE_EXIT_INTERVIEW,
    'Other'
  ]
  FINANCE_TYPES = [TYPE_SALARY, TYPE_PERFORMANCE_REVIEW, TYPE_EXIT_INTERVIEW]

  belongs_to :person, counter_cache: true, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :type, :person, :value, presence: true
  validates :type, inclusion: { in: TYPES }
end
