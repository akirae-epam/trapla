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
end
