require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  context "Authenticated as an admin" do
    setup do
      @comment = Factory.create(:comment)
      authenticate_as_admin
    end
    
    should "see comment index page" do
      get :index, :proposition_id => @comment.proposition.id
      assert_template 'index'
    end
    
    should "view show comment page" do
      get :show, :proposition_id => @comment.proposition.id, :id => @comment.id
      assert_template 'show'
    end
    
    should "be able to edit comment" do
      get :edit, :proposition_id => @comment.proposition.id, :id => @comment.id
      assert_template 'edit'
    end
    
    should "see error on create invalid comment" do
      proposition = Factory.create(:proposition)
      Comment.any_instance.stubs(:valid?).returns(false)
      post :create, :proposition_id => proposition.id
      assert_redirected_to proposition
    end
    
    should "be able to update comment" do
      comment = Factory.create(:comment)
      Comment.any_instance.stubs(:valid?).returns(true)
      put :update, :proposition_id => comment.proposition.id, :id => comment.id
      assert_redirected_to assigns(:proposition)
    end
    
    should "be able to destroy comment" do
      comment = Factory.create(:comment)
      delete :destroy, :proposition_id => comment.proposition.id, :id => comment.id
      assert_equal "Successfully destroyed comment.", flash[:notice]
      assert_redirected_to comment.proposition
      assert !Comment.exists?(comment.id), "Comment should be destroyed"
    end
    
  end
  
  context "Authenticated as user" do
    setup do
      authenticate_as_user
    end
    
    should "be able to create comment" do
      proposition = Factory.create(:proposition)
      Comment.any_instance.stubs(:valid?).returns(true)
      post :create, :proposition_id => proposition.id
      assert_redirected_to proposition
    end
    
    should "not be able to destroy comment" do
      comment = Factory.create(:comment)
      delete :destroy, :proposition_id => comment.proposition.id, :id => comment.id
      assert_redirected_to root_url
      assert_equal I18n.translate('flash.errors.not_authorized'), flash[:error]
    end
    
    should "not be able to update comment" do
      comment = Factory.create(:comment)
      put :update, :proposition_id => comment.proposition.id, :id => comment.id
      assert_redirected_to root_url
      assert_equal I18n.translate('flash.errors.not_authorized'), flash[:error]
    end
    
  end
  
  context "As guest" do
    setup do
      not_logged_in
    end
    
    should "not be able to create comment" do
      proposition = Factory.create(:proposition)
      post :create, :proposition_id => proposition.id, :comment => {:body => "test"}
      assert_redirected_to root_url
      assert_equal I18n.translate('flash.errors.anonymous_not_authorized'), flash[:error]
    end
  end
end
