class PeopleController < ApplicationController
  def index
    @q = Person.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @people = @q.result(distinct: true)

    if params.dig(:q, :by_tag_including)
      @people = @people.tagged_with(params[:q][:by_tag_including], any: true)
    end
    if params.dig(:q, :by_tag_excluding)
      @people = @people.tagged_with(params[:q][:by_tag_excluding], exclude: true)
    end

    @people = @people.limit(params[:limit]).offset(params[:offset])
      .includes(:notes, :attachments, :assessments, :action_points)
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to people_path, flash: { success: 'Person created' }
    else
      flash.now[:error] = 'Person was not created'
      render :new
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to people_path, flash: { success: 'Person updated' }
    else
      flash.now[:error] = 'Person was not updated'
      render :edit
    end
  end

private

  def person_params
    params.require(:person).permit(:name, :city, :phone, :skype, :linkedin, :facebook, :wants_relocate,
      :primary_tech, :english, :priority, :cultural_fit, :day_of_birth, tag_list: [])
  end
end
