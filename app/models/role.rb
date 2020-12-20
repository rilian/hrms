class Role < ActiveRecord::Base

  def self.admin
    all.find_by(name: 'admin')
  end

  def is_admin?
    name == 'admin'
  end

end
