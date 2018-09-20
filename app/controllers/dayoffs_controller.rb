class DayoffsController < ApplicationController
  include DayoffsHelper
  load_and_authorize_resource

  def index
    @q = Dayoff.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @dayoffs = @q.result

    @dayoffs = @dayoffs.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @dayoffs = @dayoffs.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @dayoffs = @dayoffs.includes(:person)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def show
  end

  def employees
    @employees = Person.accessible_by(current_ability, :read).not_deleted.current_employee.order(:name)

    respond_to do |format|
      format.html
      format.xlsx do
        Axlsx::Package.new do |p|
          p.use_shared_strings = true
          wb = p.workbook
          wb.add_worksheet(name: 'Dayoffs') do |sheet|
            sheet.add_row [
              'Name',
              'Start Date',
              'Months worked',
              'Current year',
              'Period start',
              'Period end',
              'Vacation days assigned',
              'Vacation days total for period',
              'Vacation days used',
              'Remain vacation days',
              'Days may burn by period end',
              'Days transfer to next period',
              'Overtimes',
              'Sick leaves',
              'Unpaid days off',
              'Paid days off',
              'Work day shifts'
            ]

            @employees.each do |record|
              if record.start_date.present? && record.start_date <= Time.zone.now
                vacation_stats_per_year(record.id).tap do |stats|
                  stats[stats.keys.last].tap do |stat|
                    sheet.add_row [
                      record.name,
                      record.start_date.strftime(t(:day)).gsub('00:00, ', ''),
                      months_worked(record),
                      (stat['year'] + 1).to_i,
                      stat['period_start_date'],
                      stat['period_end_date'],
                      stat['yearly_vacation_days_assigned'],
                      stat['total_vacation_days'],
                      stat['used_vacation'],
                      stat['remaining_vacation'],
                      stat['burn_days'],
                      stat['transfer_days'],
                      stat['overtime_days'],
                      stat['sick_leave_days'],
                      stat['unpaid_days_off'],
                      stat['paid_days_off'],
                      stat['working_days_shifts']
                    ]
                  end
                end
              end
            end
          end

          send_data p.to_stream().read, filename: "dayoffs-#{Time.zone.now.strftime(t(:for_csv)).gsub('00:00, ', '')}.xlsx"
          return
        end
      end
    end
  end

  def new
  end

  def create
    if @dayoff.save
      log_event(entity: @dayoff, action: 'created')
      @dayoff.person.update(created_by_name: current_user.email, updated_by_name: current_user.email)
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || dayoffs_path, flash: { success: 'Day off created' }
    else
      flash.now[:error] = 'Day off was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @dayoff.update(dayoff_params)
      log_event(entity: @dayoff, action: 'updated')
      @dayoff.person.update(updated_by_name: current_user.email)
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
