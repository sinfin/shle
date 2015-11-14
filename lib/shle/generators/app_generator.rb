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

      if yes?("'#{app_name}' was generated. Do you want to run bin/setup?")
	system 'bin/setup'
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


end
