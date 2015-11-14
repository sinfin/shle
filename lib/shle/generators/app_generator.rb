require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Shle
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :domain, type: :string, required: true,
    desc: "Primary production domain (used for droplet name)"

    class_option :port, type: :string, required: true,
    desc: "Development port of the application"

    class_option :database, type: :string, aliases: "-d", default: "postgresql",
    desc: "Configure for selected database (options: #{DATABASES.join("/")})"

    class_option :skip_turbolinks, type: :boolean, default: true,
    desc: "Skip turbolinks gem"

    class_option :skip_bundle, type: :boolean, aliases: "-B", default: true,
      desc: "Don't run bundle install"

    def finish_template
      super
      remove_file 'app/assets/javascripts/application.js'
      remove_file 'app/assets/stylesheets/application.css'
      remove_file 'app/views/layouts/application.html.erb'

      directory 'skeleton', '.'
      template 'config/environments/production.rb.tt', 'config/environments/staging.rb'

      build :config_application_rb

      environment nil, env: 'development' do
        'config.logger = Logger.new(STDOUT)'
      end
    end

    protected

    def primary_domain
      options[:domain]
    end

    def production_port
      options[:port].to_i
    end

    def dev_port
      options[:port].to_i
    end

    def staging_s3_bucket
      fetch_env('STAGING_S3_BUCKET_NAME')
    end

    def staging_aws_access_key_id
      fetch_env('STAGING_AWS_ACCESS_KEY_ID')
    end

    def staging_aws_secret_access_key
      fetch_env('STAGING_AWS_SECRET_ACCESS_KEY')
    end

    private

    def fetch_env_erb(key)
      "<%= ENV['#{key}'] %>"
    end

    alias :fetch_env_for_erb :fetch_env_erb

    def fetch_env(key)
      raise "Add #{key} into your environment and re-run the script" unless ENV.has_key?(key)
      ENV[key]
    end

    def get_builder_class
      Shle::AppBuilder
    end
  end

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

      application config


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
