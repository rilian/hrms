class TagsController < ApplicationController
  load_and_authorize_resource

  def index
    @tags = Person.accessible_by(current_ability).tag_counts_on(:tags)
  end
end
