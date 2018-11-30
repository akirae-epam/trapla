Rails.application.routes.draw do

  #StaticPagesController
  root 'static_pages#home'

  #UsersController
  resources :users
  get 'signup', to:'users#new'
  post 'signup', to:'users#create'

  #SessionsController
  get 'login', to:'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  #AccountActivatesController
  resources :account_activations, only: [:edit]

  #PasswordResetsController
  resources :password_resets, only: [:new, :create, :edit, :update]

  #PlansController
  resources :plans
  post 'plan_details', to: 'plans#create_plan_detail'
end
