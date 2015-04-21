module Shle
  class AppBuilder < Rails::AppBuilder
    include Shle::Actions

    def config_application_rb
      config = <<-RUBY
    config.time_zone = 'Prague'

    config.i18n.available_locales = [:cs, :en]
    config.i18n.default_locale = :cs

    config.ember.app_name = 'Admin'
    config.ember.ember_path = 'app/assets/javascripts/admin'
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
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    protected

    # def env(key)
    #   unless ENV[key].presence
    #     raise "Missing environment variable "
    #   end
    # end

  end
end
