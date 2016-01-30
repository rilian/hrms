class AttachmentsController < ApplicationController
  def index
    @q = Attachment.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @attachments = @q.result.limit(params[:limit]).offset(params[:offset])
      .includes(:person)
  end

  def show
    @attachment = Attachment.find(params[:id])
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new(attachment_params)
    if @attachment.save
      redirect_to attachments_path, flash: { success: 'Attachment created' }
    else
      flash.now[:error] = 'Attachment was not created'
      render :new
    end
  end

  def edit
    @attachment = Attachment.find(params[:id])
  end

  def update
    @attachment = Attachment.find(params[:id])
    if @attachment.update(attachment_params)
      redirect_to attachments_path, flash: { success: 'Attachment updated' }
    else
      flash.now[:error] = 'Attachment was not updated'
      render :edit
    end
  end

private

  def attachment_params
    params.require(:attachment).permit(:person_id, :file, :name, :description)
  end
end
