Rails.application.routes.draw do
  devise_for :users

  resources :action_points, except: [:show, :destroy]
  resources :attachments, except: [:show, :destroy]
  resources :dayoffs do
    get :employees, on: :collection
  end
  resources :events, only: :index
  resources :notes, except: [:show, :destroy]
  resources :people do
    get :autocomplete_person_name, on: :collection
    get :autocomplete_employee_name, on: :collection
  end
  resources :reports, only: :index do
    collection do
      get :by_status
      get :by_technology
      get :current_employees_table
      get :contractors_table
      get :employees_by_birthday_month
      get :employees_simple
      get :employees_without_nda_signed
      get :funnel
      get :historical_data
      get :people_with_similar_name
      get :searches
    end
  end
  resources :search, only: :index
  resources :tags, only: :index
  resources :users, except: :destroy
  resources :vacancies, except: :destroy

  root 'home#index'
end
