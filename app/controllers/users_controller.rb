class UsersController < ApplicationController
  load_and_authorize_resource

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
      redirect_to users_path, flash: { success: 'User created' }
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
      redirect_to users_path, flash: { success: 'User updated' }
    else
      flash.now[:error] = 'User was not updated'
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :notifications_enabled, :role).tap do |p|
      p.delete(:password) if p[:password].blank?
    end
  end
end
