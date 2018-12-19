# frozen_string_literal: true

Rails.application.routes.draw do
  # StaticPagesController
  root 'static_pages#home'

  # UsersController
  resources :users, only: %i[show new create edit update destroy]
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  resources :users do
    member do
      get :following, :followers
    end
  end

  # RelationshipsController
  resources :relationships, only: %i[create destroy]

  # SessionsController
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # AccountActivatesController
  resources :account_activations, only: [:edit]

  # PasswordResetsController
  resources :password_resets, only: %i[new create edit update]

  # PlansController
  resources :plans, except: %i[index]
  get '/plans/:id/copy', to: 'plans#copy', as: 'copy_plan'

  # PlanDetailsController
  resources :plan_details, only: %i[new create edit update destroy]
end
