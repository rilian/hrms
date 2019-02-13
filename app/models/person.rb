class Person < ActiveRecord::Base
  include ChangesTracker

  acts_as_taggable_on :tags
  attachment :photo

  PRIMARY_TECHS = [
    'Android',
    'C/C++/Go',
    'DBA',
    'DevOps',
    'Frontend',
    'Fullstack',
    'Golang',
    'HR',
    'iOS',
    'Java',
    'Manager',
    'Marketing',
    'ML',
    'NET',
    'Office Manager',
    'PHP',
    'PM',
    'Python',
    'Ruby',
    'Sales',
    'Salesforce',
    'Scala',
    'QA/BA',
    'UI/UX',
    'Wordpress',
    'Xamarin'
  ]
  ENGLISH_LEVELS = %w(
    Beginner/Elementary
    Pre-Intermediate
    Intermediate
    Upper-Intermediate
    Advanced
  )
  CURRENT_EMPLOYEE_STATUSES = %w(Hired Contractor)
  EMPLOYEE_STATUSES = ['Hired', 'Past employee', 'Contractor', 'Past contractor']
  PAST_EMPLOYEE_STATUSES = EMPLOYEE_STATUSES - CURRENT_EMPLOYEE_STATUSES

  SALARY_TYPES = %w(Monthly Hourly)

  has_many :action_points
  has_many :attachments
  has_many :dayoffs
  has_many :expenses
  has_many :notes

  before_validation :cleanup
  before_save :strip_values

  validates :name, presence: true
  validates :salary_type, inclusion: { in: SALARY_TYPES }, allow_blank: true
  validates :primary_tech, inclusion: { in: PRIMARY_TECHS }
  validates :vacation_override, numericality: { only_integer: true }, allow_blank: true
  validates :email, :personal_email, :phone, :skype, :linkedin, :github, uniqueness: { case_sensitive: false, conditions: -> { not_deleted } }, allow_blank: true
  validates :name, format: { with: /\A[a-zA-Z\d\s\-\'\(\)]+\z/, message: 'invalid symbols. Only A-Z, digits, braces, quote and space allowed' }, allow_blank: true
  validates :phone, format: { with: /\A[\s\+\,\d]+\z/ }, allow_blank: true
  validates :email, :personal_email, format: { with: /\A[0-9a-z\@\.\_\-\'\+]+\z/ }, allow_blank: true
  validates :skype, format: { with: /\A[0-9a-z\.\:\_\-]+\z/ }, allow_blank: true
  validates :start_date, presence: { message: 'should be present for current employee' }, if: ->(p) { p.status.in?(EMPLOYEE_STATUSES) && !p.new_record? }
  validates :email, presence: { message: 'should be present for current employee' }, if: ->(p) { p.status.in?(CURRENT_EMPLOYEE_STATUSES) && p.start_date.present? && p.start_date <= Time.zone.now }
  validate :finish_date_greater_or_equal_start_date

  scope :not_deleted, ->() { where(is_deleted: false) }
  scope :employee, ->() { where(status: EMPLOYEE_STATUSES).order(:status) }
  scope :current_employee, ->() { where(status: 'Hired').order(:name) }

  def linkedin_value
    if self.linkedin.start_with?('https://')
      self.linkedin
    elsif self.linkedin.start_with?('http://')
      self.linkedin.gsub('http://', 'https://')
    else
      "https://#{self.linkedin}"
    end
  end

  def github_value
    if self.github.start_with?('https://')
      self.github
    elsif self.github.start_with?('http://')
      self.github.gsub('http://', 'https://')
    else
      "https://#{self.github}"
    end
  end

private

  def cleanup
    self.email = email.to_s.downcase
    self.skype = skype.to_s.downcase
  end

  def strip_values
    self.phone = self.phone.to_s.strip.gsub(' ', '')
    self.current_position = self.current_position.to_s.strip
    self.email = self.email.to_s.strip
    self.personal_email = self.personal_email.to_s.strip
    self.skype = self.skype.to_s.strip
    self.linkedin = self.linkedin.to_s.chomp('/').strip
    self.github = self.github.to_s.strip.split('?').first.to_s.strip
    self.name = self.name.to_s.strip
    self.telegram = self.telegram.to_s.strip
  end

  def finish_date_greater_or_equal_start_date
    return if start_date.blank? || finish_date.blank? || start_date <= finish_date
    errors.add(:start_date, 'should be earlier than finish_date')
  end
end
