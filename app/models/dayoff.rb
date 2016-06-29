class Dayoff < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = ['Vacation', 'Sick Leave']

  belongs_to :person

  validates :person, presence: true
  validates :type, inclusion: { in: TYPES }
end
