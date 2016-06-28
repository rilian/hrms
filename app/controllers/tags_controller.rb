class TagsController < ApplicationController
  def index
    @tags = Person.not_deleted.accessible_by(current_ability).tag_counts_on(:tags)
      .sort { |t1, t2| t2.taggings_count <=> t1.taggings_count }
    @vacancy_tags = Vacancy.order(created_at: :desc).pluck(:tag)
  end
end
