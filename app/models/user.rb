class User < ActiveRecord::Base
  include ChangesTracker

  devise :database_authenticatable, :recoverable, :validatable

  belongs_to :role, optional: true

  delegate :is_admin?, to: :role, allow_nil: true


  def is_user?
    role.nil?
  end

end
