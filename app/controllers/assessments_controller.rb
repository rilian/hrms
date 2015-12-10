class AssessmentsController < ApplicationController
  def index
    @q = Assessment.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @assessments = @q.result.limit(params[:limit]).offset(params[:offset])
      .includes(:person)
  end

  def new
    @assessment = Assessment.new
  end

  def create
    @assessment = Assessment.new(assessment_params)
    @assessment.update_value(params[:values]) if params[:values]
    if @assessment.save
      redirect_to assessments_path, flash: { success: 'Assessment created' }
    else
      render :new
    end
  end

private

  def assessment_params
    params.require(:assessment).permit(:person_id)
  end
end