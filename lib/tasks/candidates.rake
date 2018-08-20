namespace :candidates do
  desc 'Finds duplicates'
  task similars: :environment do
    puts SimilarsCollector.new.perform
  end
end
