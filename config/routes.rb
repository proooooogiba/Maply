Rails.application.routes.draw do
  root "maps#index"
  
  resources :rooms do
    resources :messages
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
  end

  get 'user/:id', to: 'users#show', as: :user
  
  get 'maps/index', as: :maps
  post '/result', to: 'maps#result'
  # get 'users/index', as: :user_index
  get 'users/show', as: :user_show
  get 'users/sign_out', as: :user_sign_out
  get 'users/sign_in', as: :user_sign_in
  get 'users/user_profile', as: :user_profile
  
  # Defines the root path route ("/")
  resources :users, only: [:index]
end
