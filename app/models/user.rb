class User < ActiveRecord::Base
  include ChangesTracker

  devise :database_authenticatable, :recoverable, :validatable
end
