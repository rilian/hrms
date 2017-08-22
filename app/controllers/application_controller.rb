class ApplicationController < ActionController::Base
  include Concerns::Event

  protect_from_forgery with: :exception

  if ENV['HTTP_BASIC_AUTH_ENABLED'] == 'true'
    http_basic_authenticate_with name: ENV['HTTP_BASIC_AUTH_NAME'], password: ENV['HTTP_BASIC_AUTH_PASSWORD']
  end

  before_action :authenticate_user!
  before_action :store_return_to_path, only: :index
  before_action :deep_strip_params, only: :index

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_url, flash: { error: e.message }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    redirect_to root_url, flash: { error: e.message }
  end

  private

  def store_return_to_path
    session[:return_to] = {} if session[:return_to].blank?
    session[:return_to][request.params[:controller]] = request.fullpath unless request.fullpath.include?('.json')
  end

  def deep_strip_params
    params.each_pair do |k, v|
      if v.is_a?(Hash) || v.is_a?(ActionController::Parameters)
        deep_strip_params!(v)
      elsif v.is_a?(Array)
        v.each_with_index do |v2, index|
          v[index] = v2.squish
        end
      else
        params[k] = v.to_s.squish
      end
    end
  end

  def deep_strip_params!(hash)
    hash.each_pair do |k, v|
      if v.is_a?(Array)
        v.each_with_index do |v2, index|
          v[index] = v2.squish
        end
      else
        hash[k] = v.squish
      end
    end
  end
end
