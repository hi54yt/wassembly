require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "Authenticated as an admin" do
    setup do
      authenticate_as_admin
    end
    
    should "see admin page" do
      get :index
      assert_response :ok
      assert_template 'index'
    end
  end
  
  context "Authenticated as a regular user" do
    setup do
      authenticate_as_user
    end
    
    should "not see admin page" do
      get :index
      assert_response :redirect
      assert flash[:error] == I18n.translate('flash.errors.not_authorized')
    end
  end
  
  context "as a guest" do
    setup do
      not_logged_in
    end
    
    should "not see admin page" do
      get :index
      assert_response :redirect
      assert flash[:error] == I18n.translate('flash.errors.anonymous_not_authorized')
    end
  end
end
  
  