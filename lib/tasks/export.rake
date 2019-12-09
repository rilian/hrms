namespace :export do
  desc 'Export all attachments to zip archive'
  task all: :environment do
    perform
  end

  desc 'Export last day attachments to zip archive'
  task last_day: :environment do
    perform(start_time: Date.yesterday.midnight, end_time:  Date.yesterday.end_of_day)
  end

  def perform(**args)
    service = Exporter.new(**args)
    if service.perform
      puts "Found #{service.metadata.count} attachments"
      puts "Exported to #{service.archive_path}"
    else
      if service.errors.present?
        puts "Export failed due to errors:\n#{service.errors.join("\n")}"
      else
        puts 'Export failed due to unknown reason'
      end
    end
  end
end
