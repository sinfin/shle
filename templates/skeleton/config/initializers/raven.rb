if Rails.env.production? || Rails.env.staging?
  require 'raven'

  Raven.configure do |config|
    # TODO: setup project DSN
    config.dsn = ''
  end
end
