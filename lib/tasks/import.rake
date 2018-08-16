namespace :import do
  desc 'Loads CSV data into People table'
  task people: :environment do
    require 'smarter_csv'

    raise 'ERROR: provide CSV file path in CSV_FILE_PATH variable' unless File.exist?(ENV['CSV_FILE_PATH'])
    raise "ERROR: provide Primary Tech value (#{Person::PRIMARY_TECHS.join(', ')}) in PEOPLE_PRIMARY_TECH variable" unless Person::PRIMARY_TECHS.include?(ENV['PEOPLE_PRIMARY_TECH'])

    data = SmarterCSV.process(ENV['CSV_FILE_PATH'])
    data.each do |item|
      next if item[:name].blank? || item[:name].downcase == 'no'

      person = Person.new(name: item[:name])
      person.city = item[:city] if item[:city].present?
      person.skype = item[:skype] if item[:skype].present?
      person.linkedin = item[:linkedin] if item[:linkedin].present?
      person.github = item[:github] if item[:github].present?
      person.primary_tech = ENV['PEOPLE_PRIMARY_TECH']
      person.save!

      if item[:status].present?
        note = Note.new(person: person, type: 'Other', value: item[:status])
        note.save!
      end

      if item[:decision].present?
        note = Note.new(person: person, type: 'Decision', value: item[:decision])
        note.save!
      end
    end

    puts 'Done'
  end
end
