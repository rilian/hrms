class ActionPointsController < ApplicationController
  load_and_authorize_resource

  def index
    @q = ActionPoint.accessible_by(current_ability).ransack(params[:q])
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
  end

  def create
    @action_point = ActionPoint.new(action_point_params.merge!(updated_by: current_user))
    if @action_point.save
      log_event(entity: @action_point, action: 'created')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || action_points_path, flash: { success: 'Action created' }
    else
      flash.now[:error] = 'Action was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @action_point.update(action_point_params.merge!(updated_by: current_user))
      log_event(entity: @action_point, action: 'updated')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || action_points_path, flash: { success: 'Action updated' }
    else
      flash.now[:error] = 'Action was not updated'
      render :edit
    end
  end

private

  def action_point_params
    params.require(:action_point).permit(:person_id, :is_completed, :type, :value, :perform_on)
  end
end
