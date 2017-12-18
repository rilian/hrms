class ExpensesController < ApplicationController
  load_and_authorize_resource

  def index
    @q = Expense.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @expenses = @q.result

    @expenses = @expenses.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @expenses = @expenses.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @expenses = @expenses.includes(:person, :updated_by)

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
    if @expense.save
      log_event(entity: @expense, action: 'created')
      @expense.person.update(updated_by_id: current_user.id)
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || expenses_path, flash: { success: 'Expense created' }
    else
      flash.now[:error] = 'Expense was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params.merge!(updated_by: current_user))
      log_event(entity: @expense, action: 'updated')
      @expense.person.update(updated_by_id: current_user.id)
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || expenses_path, flash: { success: 'Expense updated' }
    else
      flash.now[:error] = 'Expense was not updated'
      render :edit
    end
  end

  def destroy
    copy = @expense.dup
    @expense.destroy
    log_event(entity: copy, action: 'deleted')
    redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || expenses_path, flash: { success: 'Expense deleted' }
  end

  private

  def expense_params
    params.require(:expense).permit(:person_id, :type, :notes, :amount, :recorded_on)
  end
end
