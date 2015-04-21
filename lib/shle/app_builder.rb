module Shle
  class AppBuilder < Rails::AppBuilder
    include Shle::Actions
  end
end
