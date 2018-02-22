class User < ActiveRecord::Base
  include ChangesTracker

  devise :database_authenticatable, :recoverable, :validatable

  belongs_to :updated_by, class_name: 'User'
end
