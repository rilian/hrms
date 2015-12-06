class PeopleController < ApplicationController
  def index
    @q = Person.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?
    @people = @q.result.limit(params[:limit]).offset(params[:offset])
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to people_path, success: 'Person Updated'
    else
      render :edit
    end
  end

private

  def person_params
    params.require(:person).permit(:name, :city, :phone, :skype, :linkedin, :facebook, :wants_relocate,
      :primary_tech, :english)
  end
end
