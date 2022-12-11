Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "maps#index"
  post '/result', to: 'maps#result'
  get 'users/index', as: :user
  get 'users/show', as: :user_show
  get 'users/sign_out', as: :user_sign_out
  get 'users/sign_in', as: :user_sign_in

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:index]
end
