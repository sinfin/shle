class PagesController < ApplicationController
  def show
    @node = Page.friendly.find(params[:id])
    render 'pages/contact' if @node.code == 'contact'
  end
end
