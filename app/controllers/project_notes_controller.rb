class ProjectNotesController < ApplicationController
  load_and_authorize_resource

  def index
    @q = ProjectNote.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @project_notes = @q.result

    @project_notes = @project_notes.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @project_notes = @project_notes.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @project_notes = @project_notes.includes(:project)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def new
  end

  def create
    @project_note = ProjectNote.new(project_note_params.merge!(created_by_name: current_user.email, updated_by_name: current_user.email))
    if @project_note.save
      log_event(entity: @project_note, action: 'created')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || project_notes_path, flash: { success: 'Project Note created' }
    else
      flash.now[:error] = 'Project Note was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @project_note.update(project_note_params.merge!(updated_by_name: current_user.email))
      log_event(entity: @project_note, action: 'updated')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || project_notes_path, flash: { success: 'Project Note updated' }
    else
      flash.now[:error] = 'Project Note was not updated'
      render :edit
    end
  end

private

  def project_note_params
    params.require(:project_note).permit(:project_id, :value)
  end
end
