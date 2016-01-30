class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable
end
