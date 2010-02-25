require 'test_helper'

class PropositionsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "Authenticated as an user" do
    setup do
      authenticate_as_user
    end
    
    should "be able to create valid propositions" do
      p = Factory.build(:proposition)
      post :create, :proposition => {:title => p.title, :body => p.body}
      proposition = assigns(:proposition)
      assert_not_nil proposition
      assert I18n.translate 'flash.notice.create_proposition_success' == flash[:notice]
      assert_redirected_to proposition_url(proposition)
    end
    
    should "not create invalid proposition" do
      Proposition.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
    
    should "be able to create proposition" do
      authenticate_as_admin
      get :new
      assert_template ''
    end
  end
  
  context "Authenticated as an admin" do
    setup do
      authenticate_as_admin
    end
    
    should "be able to edit proposition" do
      get :edit, :id => Factory.create(:proposition).id
      assert_template ''
    end

    should "see error when update invalid proposition" do
      proposition = Factory.create(:proposition)
      Proposition.any_instance.stubs(:valid?).returns(false)
      put :update, :id => proposition.id
      assert_template 'edit'
    end

    should "be able to update valid proposition" do
      authenticate_as_admin
      Proposition.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Factory.create(:proposition).id
      assert_redirected_to proposition_url(assigns(:proposition))
    end

    should "be able to destroy proposition" do
      authenticate_as_admin
      proposition = Factory.create(:proposition)
      delete :destroy, :id => proposition
      assert_redirected_to propositions_url
      assert !Proposition.exists?(proposition.id)
    end
  end
  
  context "as guest user" do
    should "see latest" do
      get :latest
      assert_response :success
      assert_template 'index'
    end
    
    should "see proposition" do
      get :show, :id => Factory.create(:proposition).id
      assert_template ''
    end
  end
  
end
