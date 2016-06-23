class Vacancy < ActiveRecord::Base
  belongs_to :updated_by, class_name: 'User'

  validates :project, :role, :description, presence: true
end
