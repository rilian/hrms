class Dayoff < ActiveRecord::Base
  include ChangesTracker

  self.inheritance_column = nil

  TYPES = ['Vacation', 'Sick Leave', 'Unpaid Day Off', 'Paid Day Off', 'Working Day Shift', 'Overtime']

  belongs_to :person, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :person, :start_on, :end_on, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :days, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 50 }

  validate :dates_order
  validate :dates_intersection
  validate :start_on_greater_or_equal_person_start_date
  validate :end_on_greater_or_equal_person_start_date
  validate :belongs_to_single_working_period

  private

  def belongs_to_single_working_period
    next_period_start_date = self.person.start_date
    next_period_start_date += 1.year while next_period_start_date <= self.start_on
    return if self.end_on < next_period_start_date
    errors.add(:end_on, 'belongs to next working period')
  end

  def dates_intersection
    scope = Dayoff.where(person_id: person_id, start_on: start_on)
    scope = scope.where('id != ?', self.id) if self.id.present?
    return unless scope.exists?
    errors.add(:start_on, 'already recorded for this person')
  end

  def dates_order
    return if start_on.blank? || end_on.blank?
    return if start_on <= end_on || (start_on > end_on && type == 'Working Day Shift')
    errors.add(:start_on, 'should be earlier than end_on')
  end

  def start_on_greater_or_equal_person_start_date
    return unless person&.start_date
    return if start_on > person.start_date
    errors.add(:start_on, 'should be later than person start_date')
  end

  def end_on_greater_or_equal_person_start_date
    return unless person&.start_date
    return if end_on > person.start_date
    errors.add(:end_on, 'should be later than person start_date')
  end
end
