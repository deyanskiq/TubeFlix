Rails.application.routes.draw do
  get 'pages/home'

  get 'pages/about'

  get 'user/index'

  get 'user/new', to: 'user#new'
  post 'users', to: 'user#create'

  # match ':controller(/:action(/:id))', :via => :get

  devise_for :users

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
    # get 'user/new', to: 'user#new', as: 'new_userr'
    # get 'user/:id', to: 'user#show' , as: 'user'
  end
  
  devise_scope :users do
    # get 'user', to: 'user#index' , as: 'users'
    post 'user', to: 'devise/registrations#new'
  end

  resources :uploads do 
    resources :comments
  end
  

  resources :uploads , only: [:show, :new, :create, :destroy]
  resources :user , only: [:destroy]

  root 'pages#home'

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
