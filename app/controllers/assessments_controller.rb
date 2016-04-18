class AssessmentsController < ApplicationController
  load_and_authorize_resource

  def index
    @q = Assessment.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @assessments = @q.result

    @assessments = @assessments.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @assessments = @assessments.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @assessments = @assessments.includes(:person)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def new
  end

  def create
    @assessment = Assessment.new(assessment_params.merge!(updated_by: current_user))
    @assessment.update_value(params[:values]) if params[:values]
    if @assessment.save
      log_event(entity: @assessment, action: 'created')
      redirect_to assessments_path, flash: { success: 'Assessment created' }
    else
      flash.now[:error] = 'Assessment was not created'
      render :new
    end
  end

  def edit
  end

  def update
    @assessment.update_value(params[:values]) if params[:values]
    if @assessment.update(assessment_params.merge!(updated_by: current_user))
      log_event(entity: @assessment, action: 'updated')
      redirect_to assessments_path, flash: { success: 'Assessment updated' }
    else
      flash.now[:error] = 'Assessment was not updated'
      render :edit
    end
  end

private

  def assessment_params
    params.require(:assessment).permit(:person_id, :created_at)
  end
end
