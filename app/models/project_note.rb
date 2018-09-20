class ProjectNote < ActiveRecord::Base
  include ChangesTracker

  self.inheritance_column = nil

  belongs_to :project, counter_cache: true, touch: true

  validates :project, :value, presence: true
end
