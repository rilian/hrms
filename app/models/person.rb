class Person < ActiveRecord::Base
  acts_as_taggable_on :tags

  PRIMARY_TECHS = %w(
    Ruby
    Frontend
    Fullstack
    NET
    Java
    iOS
    Android
    Salesforce
    DevOps
    PM
    QA/BA
    C/C++/Go
    DBA
    HR
  )
  ENGLISH_LEVELS = %w(
    Beginner/Elementary
    Pre-Intermediate
    Intermediate
    Upper-Intermediate
    Advanced
  )
  EMPLOYEE_STATUSES = ['Hired', 'Past employee']
  SOURCES = %w(Reference Djinni LinkedIn DOU)

  belongs_to :updated_by, class_name: 'User'
  has_many :action_points
  has_many :attachments
  has_many :dayoffs
  has_many :notes

  before_validation :cleanup

  validates :name, presence: true
  validates :source, inclusion: { in: SOURCES }, allow_blank: true
  validates :primary_tech, inclusion: { in: PRIMARY_TECHS }
  validates :vacation_override, numericality: { only_integer: true}, allow_blank: true
  validates :email, :phone, :skype, uniqueness: true, allow_blank: true

  scope :not_deleted, ->() { where(is_deleted: false) }
  scope :employee, ->() { where(status: EMPLOYEE_STATUSES).order(:status) }

  def linkedin_value
    if self.linkedin.start_with?('https://')
      self.linkedin
    elsif self.linkedin.start_with?('http://')
      self.linkedin.gsub('http://', 'https://')
    else
      "https://#{self.linkedin}"
    end
  end

private

  def cleanup
    self.email = email.to_s.downcase
  end
end
