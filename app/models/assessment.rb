class Assessment < ActiveRecord::Base
  validates :person, :value, presence: true
end