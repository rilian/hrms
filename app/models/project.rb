class Project < ActiveRecord::Base
  include ChangesTracker

  has_many :project_notes

  STATUSES = ['active', 'finished']

  validates :name, :description, :started_at, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
end
