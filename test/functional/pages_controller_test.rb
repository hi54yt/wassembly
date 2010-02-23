require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "Authenticated as an admin" do
    setup do
      authenticate_as_admin
    end
    
    should "see index" do
      get :index
      assert_template 'index'
    end
    
    should "see new page form" do
      get :new
      assert_template ''
    end
    
    should "see error when creating invalid page" do
      Page.any_instance.stubs(:valid?).returns(false)
      post :create
      assert_template ''
    end
    
    should "be able to create a valid page" do
      page = Factory.build(:page)
      post :create, :page => {:title => page.title, :permalink => page.permalink, :content => page.content} 
      assert_redirected_to page_url(assigns(:page))
    end
    
    should "be able to edit page" do
      get :edit, :id => Factory.create(:page).id
      assert_template ''
    end
    
    should "not be able to update page with invalid attributes" do
      page = Factory.create(:page)
      Page.any_instance.stubs(:valid?).returns(false)
      put :update, :id => page.id
      assert_template 'edit'
    end
    
    should "be able to update page" do
      Page.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Factory.create(:page).id
      assert_redirected_to page_url(assigns(:page))
    end
    
    should "be able to destroy page" do
      page = Factory.create(:page)
      delete :destroy, :id => page.id
      assert_redirected_to pages_url
      assert !Page.exists?(page.id)
    end
    
  end
  
  context "as guest" do
    setup do
      not_logged_in
    end
    
    should "see page" do
      get :show, :id => Factory.create(:page).id
      assert_template ''
    end
  end
    
end
