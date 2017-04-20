class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable

  belongs_to :updated_by, class_name: 'User', optional: true

  def accessible_note_types
    return Note::TYPES if has_access_to_finances?
    Note::TYPES - Note::FINANCE_TYPES
  end
end
