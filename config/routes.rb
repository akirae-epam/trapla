Rails.application.routes.draw do

  get 'sessions/new'

  #StaticPagesController
  root 'static_pages#home'
  get 'help', to:'static_pages#help'
  get 'about', to:'static_pages#about'

  #UsersController
  resources :users
  get 'signup', to:'users#new'
  post 'signup', to:'users#create'

  #SessionsController
  get 'login', to:'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
end
