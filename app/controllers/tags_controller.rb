class TagsController < ApplicationController
  def index
    @tags = Person.not_deleted.accessible_by(current_ability).tag_counts_on(:tags)
  end
end
