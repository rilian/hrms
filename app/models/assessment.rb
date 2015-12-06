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

  belongs_to :person

  validates :person, :value, presence: true
  validates :total, numericality: { only_integer: true }
end