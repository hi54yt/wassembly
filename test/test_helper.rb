ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "authlogic/test_case"
require "factories"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
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
