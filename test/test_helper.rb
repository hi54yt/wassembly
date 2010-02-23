ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "authlogic/test_case"

class ActiveSupport::TestCase
  
  def authenticate_as_admin
    admin = Factory.create(:admin)
    UserSession.create(admin)
  end
  
  def authenticate_as_user
    user = Factory.create(:user)
    UserSession.create(user)
  end
    
  def not_logged_in
    session = @controller.send :current_user_session
    session.destroy unless session.nil?
  end
    
end
