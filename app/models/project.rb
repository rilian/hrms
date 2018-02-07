class Project < ActiveRecord::Base
  include ChangesTracker

  belongs_to :updated_by, class_name: 'User'
  has_many :project_notes

  STATUSES = ['active', 'finished']

  validates :name, :description, :started_at, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
end
