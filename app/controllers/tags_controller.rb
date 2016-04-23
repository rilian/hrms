class TagsController < ApplicationController
  def index
    @tags = Person.accessible_by(current_ability).tag_counts_on(:tags)
  end
end
