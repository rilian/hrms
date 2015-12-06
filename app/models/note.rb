class Note < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = %w(
    decision
    skype_conversation
    skype_call
    phone_call
    ceo_opinion
    expected_salary
    tech_interview
    test_assignment
  )

  belongs_to :person

  validates :type, :person, presence: true
end