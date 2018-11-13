Rails.application.routes.draw do
  
  #StaticPagesController
  root 'static_pages#home'
  get 'help', to:'static_pages#help'
  get 'about', to:'static_pages#about'

  #UsersController
  get 'signup', to:'users#new'
end
