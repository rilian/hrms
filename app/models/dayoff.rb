class Dayoff < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = ['Vacation', 'Sick Leave']

  belongs_to :person

  validates :person, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :days, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 50 }
end
