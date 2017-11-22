class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @q = Project.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @projects = @q.result

    @projects = @projects.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @projects = @projects.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @projects = @projects.includes(:updated_by)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def new
  end

  def create
    @project = Project.new(project_params.merge!(updated_by: current_user))
    if @project.save
      log_event(entity: @project, action: 'created')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || projects_path, flash: { success: 'Project created' }
    else
      flash.now[:error] = 'Project was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params.merge!(updated_by: current_user))
      log_event(entity: @project, action: 'updated')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || projects_path, flash: { success: 'Project updated' }
    else
      flash.now[:error] = 'Project was not updated'
      render :edit
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :status, :description, :started_at)
  end
end
