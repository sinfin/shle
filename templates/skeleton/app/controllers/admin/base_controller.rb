class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def pagination_info(scope)
    {}
    # {
    #   total: scope.total_count,
    #   per_page: scope.size,
    #   total_pages: scope.total_pages,
    #   pagination_bits: Paginator.new(scope,left: 2,right: 2).pagination_bits,
    #   current_page: current_page
    # }
  end
  
end
