class NotesController < ApplicationController
  load_and_authorize_resource
  before_action :check_access, only: [:edit, :update]

  def index
    @q = Note.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @notes = @q.result

    @notes = @notes.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @notes = @notes.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @notes = @notes.includes(:person, :updated_by)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def new
  end

  def create
    @note = Note.new(note_params.merge!(updated_by: current_user))
    if @note.save
      log_event(entity: @note, action: 'created')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || notes_path, flash: { success: 'Note created' }
    else
      flash.now[:error] = 'Note was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @note.update(note_params.merge!(updated_by: current_user))
      log_event(entity: @note, action: 'updated')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || notes_path, flash: { success: 'Note updated' }
    else
      flash.now[:error] = 'Note was not updated'
      render :edit
    end
  end

private

  def check_access
    if !@note.type.in?(current_user.accessible_note_types) && !current_user.has_access_to_finances?
      flash.now[:error] = "Content of this note is not available (#{@note.type})"
      return redirect_to root_path
    end
  end

  def note_params
    params.require(:note).permit(:person_id, :type, :value)
  end
end
