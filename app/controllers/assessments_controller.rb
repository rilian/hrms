class AssessmentsController < ApplicationController
  def index
    @q = Assessment.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @assessments = @q.result.limit(params[:limit]).offset(params[:offset])
      .includes(:person)
  end
end