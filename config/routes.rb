Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'sessions#new'
  get '/help' => 'user_stories#index'
  resources :reviews

  resources :sessions
  resources :users
end
