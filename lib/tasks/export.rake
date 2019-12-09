namespace :export do
  desc 'Export all attachments to zip archive'
  task all: :environment do
    service = Exporter.new
    service.perform
    puts "Exported to #{service.archive_path}"
  end

  desc 'Export last day attachments to zip archive'
  task last_day: :environment do
    service = Exporter.new
    service.perform(start_time: Date.yesterday.midnight, end_time:  Date.yesterday.end_of_day)
    puts "Exported to #{service.archive_path}"
  end
end
