class Company < ApplicationRecord

  belongs_to :status

  attachment :logo
  attachment :favicon


  validates :name, :file, presence: true


end
