class UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
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
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, flash: { success: 'User created' }
    else
      flash.now[:error] = 'User was not created'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, flash: { success: 'User updated' }
    else
      flash.now[:error] = 'User was not updated'
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :notifications_enabled).tap do |p|
      p.delete(:password) if p[:password].blank?
    end
  end
end
