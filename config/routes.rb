Rails.application.routes.draw do
  resources :people

  root 'home#index'
end
