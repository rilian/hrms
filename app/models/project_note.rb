class ProjectNote < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :project, counter_cache: true, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :project, :value, presence: true
end
