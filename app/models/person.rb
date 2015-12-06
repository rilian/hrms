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

  has_many :assessments
  has_many :notes

  validates :name, presence: true
end