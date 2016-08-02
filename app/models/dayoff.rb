class Dayoff < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = ['Vacation', 'Sick Leave', 'Unpaid Day Off', 'Paid Day Off', 'Conference']

  belongs_to :person, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :person, :start_on, :end_on, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :days, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 50 }

  validate :dates_intersection

  private

  def dates_intersection
    scope = Dayoff.where(person_id: person_id, start_on: start_on)
    scope = scope.where('id != ?', self.id) if self.id.present?
    return unless scope.exists?
    errors.add(:start_on, 'already recorded for this person')
  end
end
