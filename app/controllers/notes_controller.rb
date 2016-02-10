class NotesController < ApplicationController
  def index
    @q = Note.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @notes = @q.result

    @notes = @notes.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @notes = @notes.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @notes = @notes.includes(:person)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def show
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      redirect_to notes_path, flash: { success: 'Note created' }
    else
      flash.now[:error] = 'Note was not created'
      render :new
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
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
