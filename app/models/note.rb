class Note < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = %w(
    skype_conversation
    skype_call
    phone_call
    tech_interview
    test_assignment
    expected_salary
    decision
    ceo_opinion
    was_recommended
    other
  )

  belongs_to :person

  validates :type, :person, presence: true
end