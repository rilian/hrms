class ActionPoint < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :person

  validates :person, presence: true
end