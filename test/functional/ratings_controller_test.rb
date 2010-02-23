require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "authenticated as admin" do
    setup do
      authenticate_as_admin
    end
    
    should "view index" do
      p = Factory :proposition
      get :index, :proposition_id => p.id
      assert_template 'index'
    end

    should "view show" do
      get :show, :id => Factory.create(:rating).id
      assert_template 'show'
    end

    should "view new" do
      get :new
      assert_template 'new'
    end
    
    should "be able to edit rating" do
      get :edit, :id => Factory.create(:rating).id
      assert_template 'edit'
    end

    should "see error on update with invalid rating" do
      rating = Factory.create(:rating)
      Rating.any_instance.stubs(:valid?).returns(false)
      put :update, :id => rating.id
      assert_template 'edit'
    end
    
    should "be able to destroy" do
      rating = Factory.create(:rating)
      delete :destroy, :id => rating
      assert_redirected_to ratings_url
      assert !Rating.exists?(rating.id)
    end
  end
  
  context "authenticated as user" do
    
    setup do
      authenticate_as_user
    end
    
    should "be able create valid rating" do
      p = Factory.create(:proposition)
      post :create, :rating => {:rateable_type => 'Proposition', :rateable_id => p.id, :value =>10}, :format => 'html'
      assert_redirected_to p
    end
    
    should "receive error on create invalid" do
      Rating.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template 'new'
    end
  end
end
