class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_tags

  def index
    @q = User.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @users = @q.result

    @users = @users.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @users = @users.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def show
  end

  def new
  end

  def create
    @user = User.new(user_params.merge!(updated_by: current_user))
    if @user.save
      log_event(entity: @user, action: 'created')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || users_path, flash: { success: 'User created' }
    else
      flash.now[:error] = 'User was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params.merge!(updated_by: current_user))
      log_event(entity: @user, action: 'updated')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || users_path, flash: { success: 'User updated' }
    else
      flash.now[:error] = 'User was not updated'
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(
      :email, :password, :has_access_to_users, :has_access_to_events, :has_access_to_finances,
      :notifications_enabled, :one_on_one_notifications_enabled,
      hide_tags: [], hide_statuses: []).tap do |p|
        p.delete(:password) if p[:password].blank?
      end
  end

  def set_tags
    @tags = Person.not_deleted.accessible_by(current_ability).tag_counts_on(:tags)
      .sort { |t1, t2| t2.taggings_count <=> t1.taggings_count }
  end
end
