class NotesController < ApplicationController
  def index
    @q = Note.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @notes = @q.result.limit(params[:limit]).offset(params[:offset])
      .includes(:person)
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
