require 'exception_loggable'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery
  include ExceptionLoggable
  helper_method :current_user_session, :current_user
  
  #Catch unauthorized access exceptions
  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      flash[:error] = t('flash.errors.anonymous_not_authorized').html_safe
    else
      flash[:error] = t('flash.errors.not_authorized').html_safe
    end
    redirect_to root_url
  end
  
  rescue_from ActionController::RedirectBackError do
    redirect_to root_path
  end
  
  private
  
  def guest_user?
    @current_user.nil? && flash.empty? && session[:announcement_hide_time].nil?
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
end
