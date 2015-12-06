class Person < ActiveRecord::Base
  PRIMARY_TECHS = %w(
    Ruby
    Frontend
    Java
    QA/BA
    iOS
    Android
    Salesforce
    Devops
  )
  ENGLISHS = %w(
    None
    Beginner
    Intermediate
    Advanced
    Native
  )

  has_many :notes

  validates :name, presence: true
end