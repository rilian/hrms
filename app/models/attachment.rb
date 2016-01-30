class Attachment < ActiveRecord::Base
  attachment :file

  belongs_to :person

  validates :person, :file, presence: true
end
