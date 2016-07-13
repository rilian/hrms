class NotesController < ApplicationController
  load_and_authorize_resource

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
      redirect_to notes_path, flash: { success: 'Note created' }
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
      redirect_to notes_path, flash: { success: 'Note updated' }
    else
      flash.now[:error] = 'Note was not updated'
      render :edit
    end
  end

private

  def note_params
    params.require(:note).permit(:person_id, :type, :value)
  end
end
