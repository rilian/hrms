class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader

  belongs_to :person

  validates :person, :name, presence: true
end
