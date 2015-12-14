Rails.application.routes.draw do
  resources :action_points
  resources :assessments
  resources :notes
  resources :people

  root 'home#index'
end
