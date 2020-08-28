class AdminController < ActionController::Base

  before_action :authorized_admin!

  layout 'admin'

  def render_modal(partial, options = {backdrop: true, keyboard: true})
    render partial: 'shared/modal', locals: { partial: partial, options: options}
  end

  def xhr_redirect_to(args)
    @args = args
    flash.keep
    render 'shared/xhr_redirect_to'
  end

  def authorized_admin!
    unless current_user.is_admin?
      flash[:error] = 'You are not authorized to access this page'
      respond_to do |format|
        format.html do
          redirect_to '/'
        end
      end
    end
  end


end
