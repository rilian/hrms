class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  ROLES = %w[admin manager]

  belongs_to :updated_by, class_name: 'User'

  validates :role, presence: true, inclusion: { in: ROLES }

  def accessible_note_types
    case role
    when 'admin'
      Note::TYPES
    when 'manager'
      Note::TYPES - Note::RESTRICTED_TYPES
    end
  end
end
