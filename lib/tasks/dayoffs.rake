namespace :dayoffs do
  desc 'Validate dayoffs'
  task validate: :environment do
    Dayoff.includes(:person).find_each do |dayoff|
      next if dayoff.valid?
      puts "Dayoff ##{dayoff.id}: #{dayoff.errors.full_messages.join(', ')}"
      puts "Person: #{dayoff.person.name}, start_date: #{dayoff.person.start_date.strftime('%a, %e %b')}, " +
        "dayoff: #{dayoff.start_on.strftime('%a, %e %b')} - #{dayoff.end_on.strftime('%a, %e %b')}"
      puts
    end
  end
end
