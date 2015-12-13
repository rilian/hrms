class Person < ActiveRecord::Base
  PRIMARY_TECHS = %w(
    Ruby
    Frontend
    Java
    iOS
    Android
    Salesforce
    DevOps
    PM
    QA/BA
  )
  ENGLISH_LEVELS = %w(
    None
    Beginner
    Intermediate
    Advanced
    Native
  )
  HIRING_PRIORITIES = %w(
    High
    Normal
    Low
  )
  SEARCH_STR = %w[name city phone skype linkedin facebook primary_tech english priority notes_value]
    .join('_or_') << '_cont'

  has_many :assessments
  has_many :notes

  validates :name, presence: true
end