class Attachment < ActiveRecord::Base
  belongs_to :person

  validates :person, :name, presence: true
end
