Rails.application.routes.draw do
  resources :assessments
  resources :notes
  resources :people

  root 'home#index'
end
