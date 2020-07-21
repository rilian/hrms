# frozen_string_literal: true

require 'csv'

class PeopleforceExporter
  attr_accessor :errors, :employees_table, :jobs_table, :dependents_table, :candidates_table, :dayoffs_table

  def initialize()
    @errors = []
    @employees_table = []
    @jobs_table = []
    @dependents_table = []
    @candidates_table = []
    @dayoffs_table = []
  end

  def perform
    Person.where(status: Person::CURRENT_EMPLOYEE_STATUSES).each do |person|
      @employees_table.append(EMPLOYEES_MAPPING.map { |mapping| mapping[:value].call(person).to_s })
      @jobs_table.append(JOBS_MAPPING.map { |mapping| mapping[:value].call(person).to_s })
      @dependents_table.append(DEPENDENTS_MAPPING.map { |mapping| mapping[:value].call(person).to_s })
    end

    @candidates_table = Person.where(status: PERSON_STATUS_COLORS.keys - Person::EMPLOYEE_STATUSES).map do |person|
      CANDIDATES_MAPPING.map { |mapping| mapping[:value].call(person).to_s }
    end

    @dayoffs_table = Dayoff.includes(:person).all
                         .flat_map { |dayoff| dayoff_to_dayoff_days(dayoff) }
                         .map { |dayoff_day| DAYOFFS_MAPPING.map { |mapping| mapping[:value].call(dayoff_day).to_s } }

    csv('employees.csv', EMPLOYEES_MAPPING, @employees_table)
    csv('jobs.csv', JOBS_MAPPING, @jobs_table)
    csv('dependents.csv', DEPENDENTS_MAPPING, @dependents_table)
    csv('candidates.csv', CANDIDATES_MAPPING, @candidates_table)
    csv('dayoffs.csv', DAYOFFS_MAPPING, @dayoffs_table)

    true
  end

  private

  DayoffDay = Struct.new(:employee_id, :date, :type)

  def dayoff_to_dayoff_days(dayoff)
    (dayoff.start_on..dayoff.end_on).to_a.map do |date|
      DayoffDay.new(dayoff.person.employee_id, date, dayoff.type)
    end
  end

  def csv(file, mappings, table)
    CSV.open(file, "wb") do |csv|
      csv << mappings.map { |mapping| mapping[:name] }
      table.each { |row| csv << row }
    end
  end

  EMPLOYEES_MAPPING = [
      {name: 'employee_id', value: Proc.new { |person| person.employee_id }},
      {name: 'first_name', value: Proc.new { |person| person.name.split(' ').first }},
      {name: 'last_name', value: Proc.new { |person| person.name.split(' ').drop(1).join(' ') }},
      {name: 'email', value: Proc.new { |person| person.email }},
      {name: 'personal_email', value: Proc.new { |person| person.personal_email }},
      {name: 'date_of_birth', value: Proc.new { |person| person.day_of_birth }},
      {name: 'gender', value: Proc.new { |person| nil }},
      {name: 'hired_on', value: Proc.new { |person| person.start_date }},
      {name: 'phone_number', value: Proc.new { |person| person.phone }},
      {name: 'mobile_number', value: Proc.new { |person| person.phone }},
      {name: 'skype_id', value: Proc.new { |person| person.skype }},
      {name: 'slack_username', value: Proc.new { |person| nil }},
      {name: 'facebook_url', value: Proc.new { |person| nil }},
      {name: 'linkedin_url', value: Proc.new { |person| person.linkedin }},
      {name: 'skills', value: Proc.new { |person| person.skills }}
  ]

  JOBS_MAPPING = [
      {name: 'employee_id', value: Proc.new { |person| person.employee_id }},
      {name: 'effective_from', value: Proc.new { |person| person.start_date }},
      {name: 'compensation', value: Proc.new { |person| nil }},
      {name: 'employment_type', value: Proc.new { |person| person.status }},
      {name: 'probation_policy', value: Proc.new { |person| nil }},
      {name: 'position', value: Proc.new { |person| person.current_position }},
      {name: 'department', value: Proc.new { |person| nil }},
      {name: 'division', value: Proc.new { |person| nil }},
      {name: 'location', value: Proc.new { |person| person.city }},
      {name: 'reporting_to_employee_id', value: Proc.new { |person| nil }}
  ]

  DAYOFFS_MAPPING = [
      {name: 'employee_id', value: Proc.new { |dayoff_day| dayoff_day.person.employee_id }},
      {name: 'date', value: Proc.new { |dayoff_day| dayoff_day.date }},
      {name: 'type', value: Proc.new { |dayoff_day| dayoff_day.type }},
  ]

  CANDIDATES_MAPPING = [
      {name: 'first_name', value: Proc.new { |person| person.name.split(' ').first }},
      {name: 'last_name', value: Proc.new { |person| person.name.split(' ').drop(1).join(' ') }},
      {name: 'email', value: Proc.new { |person| person.personal_email }},
      {name: 'gender', value: Proc.new { |person| nil }},
      {name: 'skills', value: Proc.new { |person| person.skills }},
      {name: 'phone_number', value: Proc.new { |person| person.phone }},
      {name: 'skype_id', value: Proc.new { |person| person.skype }},
      {name: 'source', value: Proc.new { |person| nil }},
      {name: 'linkedin_url', value: Proc.new { |person| person.linkedin }},
      {name: 'facebook_url', value: Proc.new { |person| nil }},
      {name: 'added_on', value: Proc.new { |person| person.created_at }},
      {name: 'date_of_birth', value: Proc.new { |person| person.day_of_birth }},
      {name: 'desired_salary', value: Proc.new { |person| person.expected_salary }},
      {name: 'currency_code', value: Proc.new { |person| nil }}
  ]

end
