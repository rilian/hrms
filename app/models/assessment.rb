class Assessment < ActiveRecord::Base
  TOPICS = [
    'Ruby',
    'Rails',
    'Backend',
    'DevOps',
    'DB',
    'NoSQL',
    'JavaScript',
    'HTML/CSS',
    'Angular',
    'React',
    'Web-mobile',
    'iOS',
    'Android',
    'OOP Theory',
    'Architecture design',
    'Algorithms',
    'Communication',
    'Team-player',
    'Independent working',
    'Eager to learn',
    'Culture Fit',
    'Work Ethics'
  ]

  GRADES = 5

  belongs_to :person
  belongs_to :updated_by, class_name: 'User'

  validates :person, presence: true
  validates :total, numericality: { only_integer: true }
  validate :value_presence

  before_validation :update_total

  def update_value(values)
    self.value = {}
    values.each do |key, val|
      self.value[key] = val if key.in?(TOPICS) && val =~ /[1-#{GRADES}]{1}/
    end
  end

private

  def value_presence
    return if self.value
    errors.add(:base, 'Please select at least one assessment topic')
  end

  def update_total
    self.total = value.values.map(&:to_i).reduce(:+)
  end
end
