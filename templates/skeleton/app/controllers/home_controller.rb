class HomeController < ApplicationController
  def index
    @node = Page.find_by(code: 'home')
  end
end
