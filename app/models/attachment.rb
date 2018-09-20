class Attachment < ActiveRecord::Base
  include ChangesTracker

  attachment :file

  belongs_to :person, counter_cache: true, touch: true

  validates :person, :file, presence: true
end
