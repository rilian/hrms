Rails.application.routes.draw do
  devise_for :users

  resources :action_points, except: [:show, :destroy]
  resources :attachments, except: [:show, :destroy]
  resources :dayoffs, except: :show
  resources :events, only: :index
  resources :notes, except: [:show, :destroy]
  resources :people do
    get :autocomplete_person_name, on: :collection
  end
  resources :tags, only: :index
  resources :users, except: [:show, :destroy]
  resources :vacancies, except: :destroy

  root 'home#index'
end
