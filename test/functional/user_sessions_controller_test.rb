require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  fixtures :users
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    UserSession.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    paco = users(:paco)
    assert_nil @controller.session
    post :create, :user_session => {:email => 'paco@example.com', :password => 'secret'}
    assert_nil flash[:error]
    assert_equal "Inicio de sesión correcto!", flash[:notice]
    assert_redirected_to root_url
    assert_equal @controller.session["user_credentials"], paco.persistence_token
  end
  
  def test_destroy
    user_session = UserSession.new(:email => 'pepito@example.com', :password => 'secret')
    user_session.save
    delete :destroy
    assert_redirected_to root_url
    assert_nil @controller.session["user_credentials"]
  end
end
