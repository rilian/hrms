# frozen_string_literal: true

describe PeopleforceExporter do
  subject { described_class.new }

  let!(:p1) { Person.create!(name: 'Roger Badger', primary_tech: 'Ruby', start_date: 3.months.ago, employee_id: 1) }
  let!(:p2) { Person.create!(name: 'Badger Roger', primary_tech: 'Sales', start_date: 3.months.ago, employee_id: 2) }
  let!(:d) { Dayoff.create!(person: p1, start_on: Date.yesterday, end_on: Date.today, type: Dayoff::TYPES[0])}

  context 'default' do
    it 'runs' do
      expect(subject.perform).to eq true
      # expect(subject.employees_table).to eq []
      # expect(subject.candidates_table).to eq []
      # expect(subject.dayoffs_table).to eq []
      # expect(subject.jobs_table).to eq []
      # expect(subject.dependents_table).to eq []
    end
  end
end
