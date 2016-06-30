Rails.application.routes.draw do
  devise_for :users

  resources :action_points, except: :destroy
  resources :attachments, except: :destroy
  resources :dayoffs, except: :destroy
  resources :events, only: :index
  resources :notes, except: :destroy
  resources :people do
    get :autocomplete_person_name, on: :collection
  end
  resources :tags, only: :index
  resources :users, except: :destroy
  resources :vacancies, except: :destroy

  root 'home#index'
end
