require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Shle
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :port, type: :string, aliases: "-P", required: true,
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

      build :config_application_rb
    end

    protected

    def server_port
      options[:port].to_i + 5000
    end

    def dev_port
      options[:port]
    end
    
    def get_builder_class
      Shle::AppBuilder
    end
  end
end
