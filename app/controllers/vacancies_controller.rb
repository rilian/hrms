class VacanciesController < ApplicationController
  def index
    @q = Vacancy.accessible_by(current_ability)
           .order('status DESC, created_at desc').ransack(params[:q])
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

    tags = [@vacancy.tag]
    tags += params[:q][:by_tag_including] if params.dig(:q, :by_tag_including)

    @people = @people.tagged_with(tags.flatten)

    @count = @people.count
    @people = @people.includes(:attachments, :action_points, :updated_by, notes: [:updated_by])

    @tags = Person.not_deleted.accessible_by(current_ability).tag_counts_on(:tags)
              .sort { |t1, t2| t2.taggings_count <=> t1.taggings_count }

    respond_to do |f|
      f.html
      f.csv do
        require 'csv'

        send_data(CSV.generate do |csv|
          csv << ['Name', 'Linkedin']
          @people.each do |item|
            csv << [item.name, item.linkedin]
          end
        end, filename: "vacancy-#{@vacancy.id}.csv")
      end
    end
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
    params.require(:vacancy).permit(:status, :project, :role, :description, :tag)
  end
end
