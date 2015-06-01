class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :devise_or_application

  def devise_or_application
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
