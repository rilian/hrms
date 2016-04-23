Dir.mkdir('/tmp/hrms-files-cache') unless File.exists?('/tmp/hrms-files-cache')
FileUtils.chmod 0777, '/tmp/hrms-files-cache'
Refile.backends['cache'] = Refile::Backend::FileSystem.new('/tmp/hrms-files-cache')

Dir.mkdir(ENV['UPLOADS_DIR']) unless File.exists?(ENV['UPLOADS_DIR'])
FileUtils.chmod 0777, ENV['UPLOADS_DIR']
Refile.backends['store'] = Refile::Backend::FileSystem.new(ENV['UPLOADS_DIR'])
