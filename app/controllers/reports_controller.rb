class ReportsController < ApplicationController
  def index
  end

  def by_status
  end

  def by_technology
    respond_to do |format|
      format.html
      format.xlsx do
        people = Person.not_deleted.accessible_by(current_ability).where(primary_tech: params[:primary_tech])

        Axlsx::Package.new do |p|
          p.use_shared_strings = true
          wb = p.workbook
          wb.add_worksheet(name: params[:primary_tech].gsub(/[^a-zA-Z\s0-9]+/, '-')) do |sheet|
            sheet.add_row [
              'Name',
              'HR Status',
              'City',
              'Email',
              'Skype',
              'Phone',
              'Notes']
            people.each do |item|
              notes = item.notes.accessible_by(current_ability).order(updated_at: :desc).map do |note|
                if !note.type.in?(Note::FINANCE_TYPES) || (note.type.in?(Note::FINANCE_TYPES) && current_user.has_access_to_finances?)
                  [
                    note.created_at.strftime(t(:day)),
                    note.value
                  ].join("\r\n".html_safe)
                end
              end.join("\r\n---------------\r\n".html_safe)
              sheet.add_row [
                item.name,
                item.status,
                item.city,
                item.email,
                item.skype,
                "'#{item.phone}",
                notes
              ]
            end
            send_data p.to_stream().read, filename: "#{params[:primary_tech].underscore}.xlsx"
          end
        end
      end
    end
  end

  def contractors_table
    @people = Person.not_deleted.accessible_by(current_ability).where(status: 'Contractor').order(:name)
  end

  def employees_without_nda_signed
    load_current_employees
    unless params[:show_all] == 'true'
      @people = @people
        .where(signed_nda: false)
        .where('start_date < ?', Time.zone.now.strftime('%F'))
    end
  end

  def employees_by_birthday_month
    load_current_employees
    @people_table = @people
      .map { |p| [p.id, p.name, p.day_of_birth&.strftime('%d %b'), p.day_of_birth&.strftime('%m-%d') || '99-99'] }
      .sort { |a, b| a[3].to_s <=> b[3].to_s }

    respond_to do |format|
      format.html
      format.xlsx do
        Axlsx::Package.new do |p|
          p.use_shared_strings = true
          wb = p.workbook
          wb.add_worksheet(name: 'Employee Birthdays') do |sheet|
            sheet.add_row %w(Date Name)

            current_month = nil
            @people_table.each do |record|
              if record[2].present? && current_month != record[2].split(' ').last
                current_month = record[2].split(' ').last
                sheet.add_row [record[2].split(' ').last, '']
              end

              sheet.add_row [record[2], record[1]]
            end
          end

          send_data p.to_stream().read, filename: "birthdays-#{Time.zone.now.strftime('%F')}.xlsx"
        end
      end
    end
  end

  def current_employees_table
    load_current_employees

    respond_to do |format|
      format.html
      format.xlsx do
        Axlsx::Package.new do |p|
          p.use_shared_strings = true
          wb = p.workbook
          wb.add_worksheet(name: 'Employees') do |sheet|
            sheet.add_row [
              'Name',
              'Date of Birth',
              'Starting Date',
              'City',
              'Email',
              'Skype',
              'Phone',
              'Position']
            @people.each do |item|
              sheet.add_row [
                item.name,
                (item.day_of_birth.present? ? item.day_of_birth.strftime(t(:for_csv)) : 'n/a'),
                (item.start_date.present? ? item.start_date.strftime(t(:for_csv)) : 'n/a'),
                item.city,
                item.email,
                item.skype,
                "'#{item.phone}",
                item.current_position
              ]
            end
          end
          send_data p.to_stream().read, filename: "colleagues-#{Time.zone.now.strftime('%F')}.xlsx"
        end
      end
    end
  end

  def current_employees_technical
    load_current_employees
  end

  def employees_expenses
    load_current_employees
  end

  def employees_history
    @people = Person.not_deleted.accessible_by(current_ability)
      .where(status: ['Hired', 'Past employee'])
      .order(:start_date)
    @people_table = @people
      .map { |p| [p.id, p.name, p.start_date&.strftime('%Y-%m'), p.start_date&.strftime('%e %b %Y'), p.finish_date&.strftime('%e %b %Y')] }
      .sort { |a, b| a[2].to_s <=> b[2].to_s } # technical field
  end

  def people_with_similar_name
    @people = SimilarsCollector.new.perform
  end

  def historical_data
    @data = HistoricalDataCollector.new.perform
  end

  def employees_simple
    load_current_employees
  end

  def employees_by_last_one_on_one_meeting_date
    load_current_employees
    @people = @people
      .where('city ILIKE ?', ENV['MAIN_CITY'])
      .where('start_date < ?', Time.zone.now.strftime('%F'))
      .reorder('last_one_on_one_meeting_at IS NOT NULL, last_one_on_one_meeting_at ASC')
      .order(:name)
  end

  def employees_without_performance_review
    load_current_employees

    params[:performance_review] = {
      next_performance_review_start_date: 10.years.ago.beginning_of_year.strftime('%d-%m-%Y'),
      next_performance_review_finish_date: Time.zone.now.end_of_month.strftime('%d-%m-%Y'),
      order: 'next_review'
    } if params[:performance_review].blank?

    if params[:performance_review][:next_performance_review_start_date].present? &&
      params[:performance_review][:next_performance_review_finish_date].present? &&
      Time.strptime(params[:performance_review][:next_performance_review_start_date], '%d-%m-%Y') > Time.strptime(params[:performance_review][:next_performance_review_finish_date], '%d-%m-%Y')
        params[:performance_review][:next_performance_review_start_date], params[:performance_review][:next_performance_review_finish_date] = params[:performance_review][:next_performance_review_finish_date], params[:performance_review][:next_performance_review_start_date]
    end

    @people = @people
      .where(skip_reviews: false)
      .where('finish_date IS NULL OR finish_date > ?', Time.zone.now.strftime('%F'))
      .where('next_performance_review_at IS NULL OR next_performance_review_at >= ? AND next_performance_review_at <= ?',
             Time.strptime(params[:performance_review][:next_performance_review_start_date], '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00',
             Time.strptime(params[:performance_review][:next_performance_review_finish_date], '%d-%m-%Y').strftime('%Y-%m-%d') + ' 00:00:00')

    unless params[:performance_review][:not_account_last_performance_review_date].present? && params[:performance_review][:not_account_last_performance_review_date] == '1'
      @people = @people
        .where('last_performance_review_at IS NULL OR last_performance_review_at < ?', 6.months.ago.strftime('%F'))
    end

    case params[:performance_review][:order].present? && params[:performance_review][:order]
      when 'next_review'
        @people = @people.reorder('last_performance_review_at IS NOT NULL, next_performance_review_at ASC')
      else 'last_review'
        @people = @people.reorder('last_performance_review_at IS NOT NULL, last_performance_review_at ASC')
    end
    @people = @people.order(:name)
  end

  def funnel
    params[:funnel] = {
      start_date: Time.zone.now.beginning_of_week.strftime('%d-%m-%Y'),
      finish_date: Time.zone.now.end_of_week.strftime('%d-%m-%Y'),
      user_email: '',
    } if params[:funnel].blank?
    params[:funnel][:start_date] = Time.zone.now.beginning_of_week.strftime('%d-%m-%Y') if params[:funnel][:start_date].blank?
    params[:funnel][:finish_date] = Time.zone.now.end_of_week.strftime('%d-%m-%Y') if params[:funnel][:finish_date].blank?
    if params[:funnel][:start_date].present? &&
      params[:funnel][:finish_date].present? &&
      Time.strptime(params[:funnel][:start_date], '%d-%m-%Y') > Time.strptime(params[:funnel][:finish_date], '%d-%m-%Y')
      params[:funnel][:start_date], params[:funnel][:finish_date] = params[:funnel][:finish_date], params[:funnel][:start_date]
    end

    @vacancies = Vacancy
    if funnel_update_params[:vacancy_id].present?
      @vacancies = @vacancies.where(id: funnel_update_params[:vacancy_id])
    else
      @vacancies = @vacancies.where(status: 'open')
    end
    @vacancies = @vacancies.order(:created_at)

    @funnel = FunnelStatsCollector.new(
      scope: Person.accessible_by(current_ability).not_deleted,
      vacancies: @vacancies,
      start_date: funnel_update_params[:start_date],
      finish_date: funnel_update_params[:finish_date],
      user_email: funnel_update_params[:user_email]
    ).perform

    if params['xlsx'].present?
      Axlsx::Package.new do |p|
        p.use_shared_strings = true
        wb = p.workbook
        wb.add_worksheet(name: 'Funnel') do |sheet|
          sheet.add_row [
            'Vacancy',
            'Created candidates',
            'Touched candidates',
            'No status',
            'Not interested or rejected',
            'Interested',
            'Interview process',
            'Passed Interview',
            'Hired',
            'Source',
            'Updated By'
          ]

          @funnel.each do |item|
            sheet.add_row [
              item[:vacancy_title],
              item[:people_created],
              item[:people_updated_count],
              item[:people_no_status_count],
              item[:people_not_interested_count],
              item[:people_interested_count],
              item[:people_interview_count],
              item[:people_passed_interview_count],
              item[:people_hired_count],
              item[:sources].map { |i| "#{i[1]} #{i[0]}" }.join("\r\n"),
              item[:updates].map { |i| "#{i[:count]} #{i[:name]}" }.join("\r\n")
            ]
          end
        end
        send_data p.to_stream().read, filename: "funnel--#{funnel_update_params[:start_date]}--#{funnel_update_params[:finish_date]}.xlsx"
        return
      end
    end
  end

  private

  def load_current_employees
    @people = Person.not_deleted.accessible_by(current_ability)
      .current_employee
      .order(:name)
  end

  def funnel_update_params
    params.require(:funnel).permit(:start_date, :finish_date, :user_email, :vacancy_id)
  end
end
