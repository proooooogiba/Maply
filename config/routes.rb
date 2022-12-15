Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "maps#index"
  get 'maps/index', as: :maps
  post '/result', to: 'maps#result'
  get 'users/index', as: :user
  get 'users/show', as: :user_show
  get 'users/sign_out', as: :user_sign_out
  get 'users/sign_in', as: :user_sign_in
  get 'users/user_profile', as: :user_profile
  
  # Defines the root path route ("/")
  resources :users, only: [:index]
end
