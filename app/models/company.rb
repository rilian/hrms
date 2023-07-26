class Company < ActiveRecord::Base

  belongs_to :status

  attachment :logo
  attachment :favicon


  validates :name, :domain, presence: true


end
