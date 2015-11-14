module Shle
  class AppBuilder < Rails::AppBuilder
    include Shle::Actions

    def config_application_rb
      config = <<-RUBY

    config.time_zone = 'Prague'
    config.i18n.available_locales = [:cs, :en]
    config.i18n.default_locale = :cs

    config.autoload_paths += Dir["\#{config.root}/lib/**/"]

    config.generators do |generate|
      generate.orm             :active_record
      generate.test_framework  :test_unit, fixture: false
      generate.stylesheets     false
      generate.javascripts     false
      generate.helper false
      generate.assets false
      generate.view_specs false
      generate.template_engine false
      # generate.template_engine :slim
    end

    # Sidekiq
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "#{ app_name }"

      RUBY

      application(config)
    end

    def ember_admin
      config = """
    config.ember.app_name = 'Admin'
    config.ember.ember_path = 'app/assets/javascripts/admin'
      """

      ember_gems = <<-RUBY
# Ember
# BEWARE: higher versions of ember-rails may break Emblem compilation
gem 'ember-rails', '0.16.2'
gem 'emblem-rails'
gem 'emblem-source', git:'https://github.com/machty/emblem.js.git', tag: '0.4.0'
gem "barber-emblem", github: "simcha/barber-emblem"
gem "ember-source", "1.9.1"
gem "ember-data-source", "1.0.0.beta.12"
RUBY

      routes = <<-RUBY
  mount Barbecue::Engine => "/admin"

  namespace :admin do
    root 'dashboard#index'
    get '/' => 'dashboard#index', as: :user_root_path

    # has to be below 'devise_for :users'
    resources :users
  end
RUBY

      application(config)
      gemfile(ember_gems)
      insert_into_file 'config/routes.rb', before: /end$/
      directory 'ember_admin', '.'
    end

  end
end
