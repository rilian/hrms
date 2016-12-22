class PeopleController < ApplicationController
  load_and_authorize_resource
  autocomplete :person, :name, full: true, scopes: [:not_deleted]
  autocomplete :employee, :name, class_name: 'Person', full: true, scopes: [:not_deleted, :employee]

  def index
    @q = Person.not_deleted.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @people = @q.result(distinct: true)

    if params.dig(:q, :by_tag_including)
      @people = @people.tagged_with(params[:q][:by_tag_including], any: true)
    end
    if params.dig(:q, :by_tag_excluding)
      @people = @people.tagged_with(params[:q][:by_tag_excluding], exclude: true)
    end

    @count = @people.count
    @people = @people.offset(params.dig(:page, :offset)) if params.dig(:page, :offset).present?
    @people = @people.limit((params.dig(:page, :limit) || ENV['ITEMS_PER_PAGE']).to_i)

    @people = @people.includes(:attachments, :action_points, :updated_by, notes: [:updated_by])

    @tags = Person.not_deleted.accessible_by(current_ability).tag_counts_on(:tags)
      .sort { |t1, t2| t2.taggings_count <=> t1.taggings_count }

    respond_to do |f|
      f.partial { render partial: 'table' }
      f.json { render json: @people }
      f.html
    end
  end

  def show
    @action_point = ActionPoint.new(person: @person)
    @attachment = Attachment.new(person: @person)
    @dayoff = Dayoff.new(person: @person)
    @note = Note.new(person: @person)
  end

  def new
  end

  def create
    @person = Person.new(person_params.merge!(updated_by: current_user))
    if @person.save
      log_event(entity: @person, action: 'created')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || people_path, flash: { success: 'Person created' }
    else
      flash.now[:error] = 'Person was not created'
      render :new
    end
  end

  def edit
  end

  def update
    if @person.update(person_params.merge!(updated_by: current_user))
      log_event(entity: @person, action: 'updated')
      redirect_to (session[:return_to] && session[:return_to][request.params[:controller]]) || people_path, flash: { success: 'Person updated' }
    else
      flash.now[:error] = 'Person was not updated'
      render :edit
    end
  end

  def destroy
    @person.update_column(:is_deleted, true)
    log_event(entity: @person, action: 'deleted')
    redirect_to people_path, flash: { success: 'Person was deleted but can be restored manually' }
  end

private

  def person_params
    params.require(:person).permit(:name, :city, :phone, :skype, :linkedin, :email, :start_date,
      :primary_tech, :english, :cultural_fit, :day_of_birth, :status, :expected_salary, :source,
      :vacation_override, :photo, :skills, :finish_date,
      tag_list: [])
  end
end
