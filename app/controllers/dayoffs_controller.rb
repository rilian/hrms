class DayoffsController < ApplicationController
  load_and_authorize_resource

  def index
    @q = Dayoff.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @dayoffs = @q.result

    @dayoffs = @dayoffs.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @dayoffs = @dayoffs.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @dayoffs = @dayoffs.includes(:person, :updated_by)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def show
  end

  def employees
    @employees = Person.accessible_by(current_ability, :read).not_deleted.current_employee.order(:name)
  end

  def new
  end

  def create
    if @dayoff.save
      log_event(entity: @dayoff, action: 'created')
      @dayoff.person.update(updated_by_id: current_user.id)
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || dayoffs_path, flash: { success: 'Day off created' }
    else
      flash.now[:error] = 'Day off was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @dayoff.update(dayoff_params.merge!(updated_by: current_user))
      log_event(entity: @dayoff, action: 'updated')
      @dayoff.person.update(updated_by_id: current_user.id)
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || dayoffs_path, flash: { success: 'Day off updated' }
    else
      flash.now[:error] = 'Day off was not updated'
      render :edit
    end
  end

  def destroy
    copy = @dayoff.clone
    @dayoff.destroy
    log_event(entity: copy, action: 'deleted')
    redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || dayoffs_path, flash: { success: 'Day off deleted' }
  end

  private

  def dayoff_params
    params.require(:dayoff).permit(:person_id, :type, :notes, :days, :start_on, :end_on)
  end
end
