if Rails.env.production?
  require 'raven'

  Raven.configure do |config|
    # TODO: setup project DSN
    config.dsn = ''
  end
end
