require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "Authenticated as an admin" do
    setup do
      authenticate_as_admin
    end
    
    should "see users index" do
      get :index
      assert_template 'index'
    end
    
    should "see user page" do
      get :show, :id => User.first
      assert_template 'show'
    end
    
    should "edit" do
      get :edit, :id => Factory.create(:user).id
      assert_template 'edit'
    end
    
    should "see error on update user with invalid attributes" do
      user = Factory.create(:user)
      User.any_instance.stubs(:valid?).returns(false)
      put :update, :id => user.id
      assert_template 'edit'
    end
    
    should "update valid" do
      User.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Factory.create(:user)
      assert_redirected_to edit_user_url(assigns(:user))
    end
  end
  
  context "as guest" do
    setup do
      not_logged_in
    end
    
    should "see new user page" do
      get :new
      assert_template 'new'
    end
    
    should "see error on create invalid user" do
      user = Factory.build(:user)
      User.any_instance.stubs(:valid?).returns(false)
      post :create, :user => {:email => user.email, :password => 'secret'}
      assert_template 'new'
    end
    
    should "be able to create valid user" do
      user = Factory.build(:user, :active => 0)
      post :create, :user => {:email => user.email, :password => 'secret', :password_confirmation => 'secret', :username => user.username}
      assert_redirected_to root_url
      assert I18n.translate('flash.info.registration_completed'), flash[:notice]
      assert !ActionMailer::Base.deliveries.empty?
    end
  end
end
