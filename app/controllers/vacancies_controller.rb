class VacanciesController < ApplicationController
  def index
    @q = Vacancy.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @vacancies = @q.result

    @vacancies = @vacancies.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @vacancies = @vacancies.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @vacancies = @vacancies.includes(:updated_by)

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.html
    end
  end

  def show
    @vacancy = Vacancy.find(params[:id])

    @q = Person.not_deleted.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @people = @q.result(distinct: true)
    @people = @people.tagged_with(@vacancy.tag, any: true)
    @count = @people.count
    @people = @people.includes(:attachments, :action_points, :updated_by, notes: [:updated_by])
  end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = Vacancy.new(vacancy_params.merge!(updated_by: current_user))
    if @vacancy.save
      log_event(entity: @vacancy, action: 'created')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || vacancies_path, flash: { success: 'Vacancy created' }
    else
      flash.now[:error] = 'Vacancy was not created'
      render :new
    end
  end

  def edit
    @vacancy = Vacancy.accessible_by(current_ability).find(params[:id])
  end

  def update
    @vacancy = Vacancy.accessible_by(current_ability).find(params[:id])
    if @vacancy.update(vacancy_params.merge!(updated_by: current_user))
      log_event(entity: @vacancy, action: 'updated')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || vacancies_path, flash: { success: 'Vacancy updated' }
    else
      flash.now[:error] = 'Vacancy was not updated'
      render :edit
    end
  end

private

  def vacancy_params
    params.require(:vacancy).permit(:project, :role, :description, :tag)
  end
end
