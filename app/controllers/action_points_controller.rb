class ActionPointsController < ApplicationController
  def index
    @q = ActionPoint.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @action_points = @q.result

    @action_points = @action_points.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @action_points = @action_points.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @action_points = @action_points.includes(:person)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def new
    @action_point = ActionPoint.new
  end

  def create
    @action_point = ActionPoint.new(action_point_params)
    if @action_point.save
      log_event(entity: @action_point, action: 'created')
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
      log_event(entity: @action_point, action: 'updated')
      redirect_to action_points_path, flash: { success: 'ActionPoint updated' }
    else
      flash.now[:error] = 'ActionPoint was not updated'
      render :edit
    end
  end

private

  def action_point_params
    params.require(:action_point).permit(:person_id, :is_completed, :type, :value, :perform_on, :created_at)
  end
end
