class Dayoff < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = ['Vacation', 'Sick Leave']

  belongs_to :person, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :person, :start_on, :end_on, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :days, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 50 }
end
