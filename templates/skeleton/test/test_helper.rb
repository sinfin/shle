ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  def json_response
    JSON.parse(response.body)
  end

  def json
    JSON.parse(response.body).deep_symbolize_keys
  end
end


class ActionController::TestCase
  include Devise::TestHelpers
end
