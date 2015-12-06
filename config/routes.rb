Rails.application.routes.draw do
  resources :notes
  resources :people

  root 'home#index'
end
