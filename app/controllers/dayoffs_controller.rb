class DayoffsController < ApplicationController
  load_and_authorize_resource

  def create
    if @dayoff.save
      log_event(entity: @dayoff, action: 'created')
      redirect_to person_path(@dayoff.person), flash: { success: 'Day off created' }
    else
      flash.now[:error] = 'Day off was not created'
      render :new
    end
  end

  def destroy
    copy = @dayoff.dup
    @dayoff.destroy
    log_event(entity: copy, action: 'deleted')
    redirect_to person_path(copy.person), flash: { success: 'Day off deleted' }
  end

  private

  def dayoff_params
    params.require(:dayoff).permit(:person_id, :type, :notes, :days, :start_on, :end_on)
  end
end
