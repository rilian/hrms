class UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @users = @q.result.limit(params[:limit]).offset(params[:offset])
  end
end
