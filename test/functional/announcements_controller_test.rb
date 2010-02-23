require 'test_helper'

class AnnouncementsControllerTest < ActionController::TestCase
  setup :activate_authlogic

  context "authenticated as admin" do
    setup do
      authenticate_as_admin
    end
    
    should "view new" do
      get :new
      assert_response :success
    end
    
    should "create announcement" do
      assert_difference('Announcement.count') do
        post :create, :announcement => {:message => "Test announcement", :starts_at => Time.now, :ends_at => 1.month.from_now}
      end
      assert_redirected_to announcement_path(assigns(:announcement))
    end
    
    should "view index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:announcements)
    end
    
    should "view edit" do
      get :edit, :id => Factory.create(:announcement).to_param
      assert_response :success
    end
    
    should "be able to update announcement" do
      put :update, :id => Factory.create(:announcement).to_param, :announcement => { }
      assert_redirected_to announcement_path(assigns(:announcement))
    end
    
    should "be able to destroy announcement" do
      announcement = Factory.create(:announcement)
      assert_difference('Announcement.count', -1) do
        delete :destroy, :id => announcement.to_param
      end
      assert_redirected_to announcements_path
    end
  end
  
  context "as guest" do
    setup do
      not_logged_in
    end
    
    should "view announcement" do
      get :show, :id => Factory.create(:announcement).to_param
      assert_response :success
    end
  end
end
