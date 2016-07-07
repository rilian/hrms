class ActionPoint < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :person, counter_cache: true, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :person, :value, presence: true
end
