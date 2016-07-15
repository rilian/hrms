class ApplicationController < ActionController::Base
  include Concerns::Event

  protect_from_forgery with: :exception

  if ENV['HTTP_BASIC_AUTH_ENABLED'] == 'true'
    http_basic_authenticate_with name: ENV['HTTP_BASIC_AUTH_NAME'], password: ENV['HTTP_BASIC_AUTH_PASSWORD']
  end

  before_action :authenticate_user!
  before_action :store_return_to_path, only: :index

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_url, flash: { error: e.message }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    redirect_to root_url, flash: { error: e.message }
  end

  private

  def store_return_to_path
    session[:return_to] = {} if session[:return_to].blank?
    session[:return_to][request.params[:controller]] = request.fullpath
  end
end
