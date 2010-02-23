require 'test_helper'

class LoggedExceptionsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "Authenticated as an admin" do
    setup do
      authenticate_as_admin
    end
    
    should "view logged exception index" do
      get :index
      assert_response :ok
      assert_template 'index'
    end

    should "view logged exception" do
      get :show, :id => Factory.create(:logged_exception)
      assert_response :ok
      assert_template 'show'
    end

    should "destroy logged exception" do
      logged_exception = Factory.create(:logged_exception)
      delete :destroy, :id => logged_exception
      assert_redirected_to logged_exceptions_url
      assert !LoggedException.exists?(logged_exception.id)
    end
  end
end
