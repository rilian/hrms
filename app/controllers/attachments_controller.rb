class AttachmentsController < ApplicationController
  load_and_authorize_resource

  def index
    @q = Attachment.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @attachments = @q.result

    @attachments = @attachments.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @attachments = @attachments.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @attachments = @attachments.includes(:person, :updated_by)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def show
  end

  def new
  end

  def create
    @attachment = Attachment.new(attachment_params.merge!(updated_by: current_user))
    if @attachment.save
      log_event(entity: @attachment, action: 'created')
      redirect_to attachments_path, flash: { success: 'Attachment created' }
    else
      flash.now[:error] = 'Attachment was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @attachment.update(attachment_params.merge!(updated_by: current_user))
      log_event(entity: @attachment, action: 'updated')
      redirect_to attachments_path, flash: { success: 'Attachment updated' }
    else
      flash.now[:error] = 'Attachment was not updated'
      render :edit
    end
  end

private

  def attachment_params
    params.require(:attachment).permit(:person_id, :file, :name, :description, :created_at)
  end
end
