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
      get :employees
      get :people_with_similar_name
      get :historical_data
    end
  end
  resources :tags, only: :index
  resources :users, except: :destroy
  resources :vacancies, except: :destroy

  root 'home#index'
end
