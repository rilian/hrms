Rails.application.routes.draw do
  devise_for :users

  resources :action_points
  resources :assessments
  resources :attachments
  resources :notes
  resources :people

  root 'home#index'
end
