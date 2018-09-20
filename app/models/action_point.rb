class ActionPoint < ActiveRecord::Base
  include ChangesTracker

  self.inheritance_column = nil

  belongs_to :person, counter_cache: true, touch: true

  validates :person, :value, presence: true
end
