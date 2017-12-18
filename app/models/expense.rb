class Expense < ActiveRecord::Base
  self.inheritance_column = nil

  TYPES = ['Conference', 'Other']

  belongs_to :person, touch: true
  belongs_to :updated_by, class_name: 'User'

  validates :person, :recorded_on, :notes, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :amount, numericality: { only_integer: true, greater_than: 0 }

  validate :recorded_on_greater_or_equal_person_start_date

  private

  def recorded_on_greater_or_equal_person_start_date
    return unless person&.start_date && recorded_on
    return if recorded_on > person.start_date
    errors.add(:recorded_on, 'should be later than person start_date')
  end
end
