class TagsController < ApplicationController
  def index
    @tags = Person.not_deleted.accessible_by(current_ability).tag_counts_on(:tags)
    @vacancy_tags = Vacancy.order(created_at: :desc).pluck(:tag)
  end
end
