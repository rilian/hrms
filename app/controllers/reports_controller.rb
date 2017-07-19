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
          wb.add_worksheet(name: params[:primary_tech]) do |sheet|
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
                if note.type.in?(current_user.accessible_note_types) || (!note.type.in?(current_user.accessible_note_types) && current_user.has_access_to_finances?)
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
    @people = @people.where(signed_nda: false).order(:name)
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

  def people_with_similar_name
    @people = []
    previous_ids = []
    Person.not_deleted.accessible_by(current_ability).find_each(batch_size: 25) do |person|
      similars = Person.not_deleted.accessible_by(current_ability)
        .where('id NOT IN (?)', [person.id] + previous_ids)
        .where("(lower(name) ILIKE ?)
          OR (email IS NOT NULL AND email != '' AND email ILIKE ?)
          OR (phone IS NOT NULL AND phone != '' AND phone ILIKE ?)
          OR (skype IS NOT NULL AND skype != '' AND skype ILIKE ?)
          OR (linkedin IS NOT NULL AND linkedin != '' AND linkedin ILIKE ?)",
          "%#{person.name&.downcase&.strip}%",
          "%#{person.email&.strip&.presence || '#invalid#'}%",
          "%#{person.phone&.strip&.presence || '#invalid#'}%",
          "%#{person.skype&.strip&.presence || '#invalid#'}%",
          "%#{person.linkedin&.strip&.presence || '#invalid#'}%")

      if similars.exists?
        @people << {
          person: person,
          similars: similars
        }
        previous_ids += (similars.pluck(:id) + [person.id])
      end
    end
  end

  def historical_data
    @data = HistoricalDataCollector.new.perform
  end

  def employees_simple
    load_current_employees
  end

  private

  def load_current_employees
    @people = Person.not_deleted.accessible_by(current_ability)
      .current_employee
      .order(:name)
  end
end
