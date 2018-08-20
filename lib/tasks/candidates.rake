namespace :candidates do
  desc 'Finds duplicates'
  task similars: :environment do
    SimilarsCollector.new.perform.each do |record|
      puts "http://#{ENV['DOMAIN_NAME']}/people/#{Person.find(record[:person]).id} #{Person.find(record[:person]).name}"
      puts 'similarities:'
      %i(name email phone skype github linkedin).each do |prop|
        if record["similar_#{prop.to_s}".to_sym].present?
          record["similar_#{prop.to_s}".to_sym].each do |similar|
            puts "http://#{ENV['DOMAIN_NAME']}/people/#{similar} #{Person.find(similar).name} - #{prop} '#{Person.find(record[:person]).send(prop)}' ~ '#{Person.find(similar).send(prop)}'"
          end
        end
      end
      puts ''
    end
  end
end
