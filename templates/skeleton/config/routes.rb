Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  mount Barbecue::Engine => "/admin"    
  
  namespace :admin do
    root 'dashboard#index'
    get '/' => 'dashboard#index', as: :user_root_path

    # has to be below 'devise_for :users'
    resources :users
  end
end
