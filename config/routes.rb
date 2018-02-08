Rails.application.routes.draw do
  get 'user/index'

  devise_for :users
  
  resources :users
  resources :uploads do 
    resources :comments
  end

  root 'user#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
