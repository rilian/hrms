class Project < ActiveRecord::Base
  belongs_to :updated_by, class_name: 'User'

  STATUSES = ['active', 'finished']

  validates :name, :description, :started_at, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
end
