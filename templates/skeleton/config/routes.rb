Rails.application.routes.draw do

  # Localized routes
  scope "/:locale", locale: /cs|en/ do
    get '/', to: "home#index"
    # resources :foobars
  end

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
