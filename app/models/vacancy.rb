class Vacancy < ActiveRecord::Base
  belongs_to :updated_by, class_name: 'User'

  validates :project, :role, :description, presence: true
  validates :tag, uniqueness: { case_sensitive: false },
    format: {
      with: /\A[a-z0-9\-]+\Z/,
      message: 'format is invalid, only a-z, 0-9 and "-" characters allowed'
    }

  after_save :create_tag, on: :commit

  private

  def create_tag
    return if ActsAsTaggableOn::Tag.find_by_name(self.tag).present?
    ActsAsTaggableOn::Tag.create(name: self.tag)
  end
end
