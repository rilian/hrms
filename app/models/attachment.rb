class Attachment < ApplicationRecord
  attachment :file

  belongs_to :person, counter_cache: true, touch: true
  belongs_to :updated_by, class_name: 'User', optional: true

  validates :person, :file, presence: true
end
