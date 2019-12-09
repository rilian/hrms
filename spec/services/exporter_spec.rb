# frozen_string_literal: true

describe Exporter do
  subject { described_class.new }

  EXPECTED_FILE_METADATA_KEYS = %i[id name content_type metadata].freeze
  EXPECTED_PERSON_METADATA_KEYS = described_class::PERSON_FIELDS_TO_EXPORT

  let(:sample_file_path) { File.join(Rails.root, 'spec/samples/cv.pdf') }
  let!(:p1) { Person.create!(name: 'Vasiliy Pupkin', primary_tech: 'Ruby') }
  let!(:a1) { Attachment.create!(person: p1, file: File.new(sample_file_path), name: 'cv') }

  let!(:p2) { Person.create!(name: 'Pupok Vasiliev', primary_tech: 'Sales') }
  let!(:a2) { Attachment.create!(person: p2, file: File.new(sample_file_path), name: 'cv') }

  context 'all data' do
    it 'collects correct metadata' do
      expect(subject.perform).to eq true

      expect(subject.metadata.count).to eq 2
      expect(subject.archive_path).to be_present

      expect(subject.metadata.first.keys).to eq EXPECTED_FILE_METADATA_KEYS
      expect(subject.metadata.first[:metadata][:person].keys).to eq EXPECTED_PERSON_METADATA_KEYS

      expect(subject.metadata.first[:id]).to be_present
      expect(subject.metadata.first[:name]).to eq 'cv.pdf'
      expect(subject.metadata.first[:content_type]).to eq 'application/pdf'
      expect(subject.metadata.first[:metadata][:person][:name]).to eq 'Vasiliy Pupkin'
      expect(subject.metadata.first[:metadata][:person][:primary_tech]).to eq 'Ruby'
    end
  end

  context 'time range' do
    before do
      a1.update!(created_at: Date.yesterday.midday)
    end

    it 'collects correct metadata' do
      expect(subject.perform(start_time: Date.yesterday.midnight, end_time: Date.yesterday.end_of_day)).to eq true

      expect(subject.metadata.count).to eq 1
      expect(subject.archive_path).to be_present

      expect(subject.metadata.first.keys).to eq EXPECTED_FILE_METADATA_KEYS
      expect(subject.metadata.first[:metadata][:person].keys).to eq EXPECTED_PERSON_METADATA_KEYS

      expect(subject.metadata.first[:id]).to be_present
      expect(subject.metadata.first[:name]).to eq 'cv.pdf'
      expect(subject.metadata.first[:content_type]).to eq 'application/pdf'
      expect(subject.metadata.first[:metadata][:person][:name]).to eq 'Vasiliy Pupkin'
      expect(subject.metadata.first[:metadata][:person][:primary_tech]).to eq 'Ruby'
    end
  end
end
