class TagsController < ApplicationController
  def index
    @tags = Person.tag_counts_on(:tags)
  end
end
