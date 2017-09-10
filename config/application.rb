require File.expand_path('../boot', __FILE__)

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module HRMS
  class Application < Rails::Application
    config.autoload_paths += Dir[
      "#{config.root}/app/models/**/",
      "#{config.root}/app/services/**/",
      "#{config.root}/app/workers/**/",
      "#{config.root}/app/helpers/**/",
      "#{config.root}/lib/**/"
    ]

    config.active_record.schema_format = :sql
    config.time_zone = 'UTC'
  end
end
