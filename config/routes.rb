# frozen_string_literal: true

Rails.application.routes.draw do
  root 'maps#index'

  resources :rooms do
    resources :messages
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
  end

  post 'user/:id/', to: 'users#create'
  post 'user/:id/follow', to: 'users#follow', as: 'follow'
  post 'user/:id/unfollow', to: 'users#unfollow', as: 'unfollow'
  post 'user/:id/accept', to: 'users#accept', as: 'accept'
  post 'user/:id/decline', to: 'users#decline', as: 'decline'
  post 'user/:id/cancel', to: 'users#cancel', as: 'cancel'

  get 'user/show_user_profile/:id', to: 'users#show_user_profile', as: :show_user_profile

  get 'user/:id', to: 'users#show', as: :user

  get 'maps/index', as: :maps
  post '/find_nearest', to: 'maps#find_nearest', as: :find_nearest
  post '/find_nearest_friend', to: 'maps#find_nearest_friend', as: :find_nearest_friend
  post '/result', to: 'maps#result', as: :result
  get 'users/show', as: :user_show
  get 'users/sign_out', as: :user_sign_out
  # post '/users/sign_out'
  get 'users/sign_in', as: :user_sign_in
  get 'users/user_profile', as: :user_profile
  get 'users/edit', as: :user_edit

  resources :users, only: [:index]
end
