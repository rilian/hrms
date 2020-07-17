# frozen_string_literal: true

# Employees
# employee_id     people.employee_id
# first_name      people.name ?
# last_name       people.name ?
# email           people.email
# personal_email  people.personal_email
# date_of_birth   people.day_of_birth
# gender          ?
# hired_on        people.start_date ?
# phone_number    people.phone ?
# mobile_number   people.phone ?
# skype_id        people.skype
# slack_username  no info
# facebook_url    no info
# linkedin_url    people.linkedin
# skills          people.skills

# Job
# employee_id       people.employee_id
# effective_from    people.start_date ?
# compensation      ?
# employment_type   ?
# probation_policy  ?
# position          current_position
# department        ?
# division          ?
# location          ?
# reporting_to_employee_id  ?

# Leave History
# employee_id       dayoffs.person.employee_id
# date              dayoffs.start_on...dayoffs.end_on
# type              dayoffs.type

# Dependents  ?
# employee_id
# first_name
# last_name
# date_of_birth
# gender

# Candidates
# first_name        people.name ?
# last_name         people.name ?
# email             people.personal_email ?
# gender            ?
# skills            people.skills
# phone_number      people.phone
# skype_id          people.skype
# source            people.source
# linkedin_url      people.linkedin
# facebook_url      ?
# added_on          people.created_at ?
# date_of_birth     people.day_of_birth
# desired_salary    people.expected_salary
# currency_code     ?

require 'csv'

class PeopleforceExporter
  attr_accessor :errors, :employees_table, :jobs_table, :dependents_table, :candidates_table, :dayoffs_table

  def initialize()
    @errors = []
  end

  def perform
    employees_mapping = [
        {name: 'employee_id', value: Proc.new { |person| person.employee_id }},
        {name: 'first_name', value: Proc.new { |person| person.name.split(' ').first }},
        {name: 'last_name', value: Proc.new { |person| person.name.split(' ').drop(1).join('') }},
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

    jobs_mapping = [
        {name: 'employee_id', value: Proc.new { |person| person.employee_id }},
        {name: 'effective_from', value: Proc.new { |person| person.start_date }},
        {name: 'compensation', value: Proc.new { |person| nil }},
        {name: 'employment_type', value: Proc.new { |person| nil }},
        {name: 'probation_policy', value: Proc.new { |person| nil }},
        {name: 'position', value: Proc.new { |person| person.current_position }},
        {name: 'department', value: Proc.new { |person| nil }},
        {name: 'division', value: Proc.new { |person| nil }},
        {name: 'location', value: Proc.new { |person| nil }},
        {name: 'reporting_to_employee_id', value: Proc.new { |person| nil }}
    ]

    dayoffs_mapping = [
        {name: 'employee_id', value: Proc.new { |dayoff| dayoff[:employee_id] }},
        {name: 'date', value: Proc.new { |dayoff| dayoff[:date] }},
        {name: 'type', value: Proc.new { |dayoff| dayoff[:type] }},
    ]

    dependents_mapping = [
        {name: 'employee_id', value: Proc.new { |person| person.employee_id }},
        {name: 'first_name', value: Proc.new { |person| nil }},
        {name: 'last_name', value: Proc.new { |person| nil }},
        {name: 'date_of_birth', value: Proc.new { |person| nil }},
        {name: 'gender', value: Proc.new { |person| nil }},
    ]

    candidates_mapping = [
        {name: 'first_name', value: Proc.new { |person| person.name.split(' ').first }},
        {name: 'last_name', value: Proc.new { |person| person.name.split(' ').drop(1).join('') }},
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

    @employees_table = []
    @jobs_table = []
    @dependents_table = []
    @candidates_table = []
    @dayoffs_table = []

    Person.all.each do |person|
      @employees_table.append(employees_mapping.map { |mapping| mapping[:value].call(person).to_s })
      @jobs_table.append(jobs_mapping.map { |mapping| mapping[:value].call(person).to_s })
      @dependents_table.append(dependents_mapping.map { |mapping| mapping[:value].call(person).to_s })
      @candidates_table.append(candidates_mapping.map { |mapping| mapping[:value].call(person).to_s })
    end

    Dayoff.includes(:person).all
        .flat_map do |dayoff|
          (dayoff.start_on..dayoff.end_on).to_a.map do |date|
            {
                employee_id: dayoff.person.employee_id,
                date: date,
                type: dayoff.type
            }
          end
        end
        .each do |dayoff|
      @dayoffs_table.append(dayoffs_mapping.map { |mapping| mapping[:value].call(dayoff).to_s })
    end

    csv('employees.csv', employees_mapping, @employees_table)
    csv('jobs.csv', jobs_mapping, @jobs_table)
    csv('dependents.csv', dependents_mapping, @dependents_table)
    csv('candidates.csv', candidates_mapping, @candidates_table)
    csv('dayoffs.csv', dayoffs_mapping, @dayoffs_table)

    true
  end

  def csv(file, mappings, table)
    CSV.open(file, "wb") do |csv|
      csv << mappings.map { |mapping| mapping[:name] }
      table.each { |row| csv << row }
    end
  end
end
