namespace :dayoffs do
  desc 'Validate dayoffs'
  task validate: :environment do
    Dayoff.includes(:person).find_each do |dayoff|
      puts "Dayoff ##{dayoff.id}: #{dayoff.errors.full_messages.join(', ')}" unless dayoff.valid?
      puts "Person: #{dayoff.person.name}, start_date: #{dayoff.person.start_date}, " +
        "dayoff: #{dayoff.start_on.to_s} - #{dayoff.end_on.to_s}"
      puts
    end
  end
end
