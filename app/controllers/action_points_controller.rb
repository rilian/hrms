class ActionPointsController < ApplicationController
  def index
    @q = ActionPoint.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @action_points = @q.result.limit(params[:limit]).offset(params[:offset])
      .includes(:person)
  end

  def new
    @action_point = ActionPoint.new
  end

  def create
    @action_point = ActionPoint.new(action_point_params)
    if @action_point.save
      redirect_to action_points_path, flash: { success: 'ActionPoint created' }
    else
      flash.now[:error] = 'ActionPoint was not created'
      render :new
    end
  end

  def edit
    @action_point = ActionPoint.find(params[:id])
  end

  def update
    @action_point = ActionPoint.find(params[:id])
    if @action_point.update(action_point_params)
      redirect_to action_points_path, flash: { success: 'ActionPoint updated' }
    else
      flash.now[:error] = 'ActionPoint was not updated'
      render :edit
    end
  end

private

  def action_point_params
    params.require(:action_point).permit(:person_id, :is_completed, :type, :value, :perform_on)
  end
end
