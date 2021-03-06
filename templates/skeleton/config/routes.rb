Rails.application.routes.draw do
  # Localized routes
  scope '/:locale', locale: /cs|en/ do
    get '/', to: 'home#index'

    resources :leads
    get '/:id', to: 'pages#show', as: :page, constraints: { id: /[\w-]+/, format: :html }
  end

  root 'home#index'

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Sidekiq for authenticated
  require 'sidekiq/web'
  # TODO: authenticate :user, lambda { |u| u.admin? } do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
