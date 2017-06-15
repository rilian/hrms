class Search < ActiveRecord::Base
  validates :query, :ip, :path, presence: true
end
