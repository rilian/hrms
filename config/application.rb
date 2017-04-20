require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HRMS
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_record.schema_format = :sql
    config.time_zone = 'UTC'

    config.autoload_paths += Dir[
      "#{config.root}/app/models/**/",
      "#{config.root}/app/services/**/",
      "#{config.root}/app/workers/**/",
      "#{config.root}/app/helpers/**/",
      "#{config.root}/lib/**/"
    ]
  end
end
