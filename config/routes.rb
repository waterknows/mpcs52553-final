Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'sessions#new'

  #http://guides.rubyonrails.org/routing.html#adding-more-restful-actions
  resources :documents
  resources :models
  resources :sessions
  resources :users
end
