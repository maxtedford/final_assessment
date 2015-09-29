Rails.application.routes.draw do

  root 'welcome#show'
  get 'login', to: 'sessions#new'
  
  resources :riders, only: [:new, :create]
  resources :drivers, only: [:new, :create]
end
