class ApplicationController < ActionController::Base
  include Concerns::Event

  protect_from_forgery with: :exception

  if ENV['HTTP_BASIC_AUTH_ENABLED'] == 'true'
    http_basic_authenticate_with name: ENV['HTTP_BASIC_AUTH_NAME'], password: ENV['HTTP_BASIC_AUTH_PASSWORD']
  end

  before_action :authenticate_user!
end
