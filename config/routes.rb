Rails.application.routes.draw do
  devise_for :users

  resources :action_points
  resources :assessments
  resources :attachments
  resources :events, only: :index
  resources :notes
  resources :people do
    get :autocomplete_person_name, on: :collection
  end
  resources :tags, only: :index
  resources :users

  root 'home#index'
end
