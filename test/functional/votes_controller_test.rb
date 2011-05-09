require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  # called before every single test
  context "authenticated as admin" do
    setup do
      authenticate_as_admin
    end
    
    should "see votes index" do
      get :index, :proposition_id => Factory.create(:proposition).id
      assert_template ''
    end
    
    should "see show vote page" do
      vote = Factory.create(:vote)
      get :show, :proposition_id => vote.proposition.id, :id => vote.id
      assert_template ''
    end
    
    should "be able to edit vote" do
      vote = Factory.create(:vote)
      get :edit, :proposition_id => vote.proposition.id, :id => vote.id
      assert_template ''
    end
    
    should "see error on update with invalid record" do
      vote = Factory.create(:vote)
      Vote.any_instance.stubs(:valid?).returns(false)
      put :update, :proposition_id => vote.proposition.id, :id => vote.id
      assert_template 'edit'
    end

    should "update with valid record" do
      vote = Factory.create(:vote)
      Vote.any_instance.stubs(:valid?).returns(true)
      put :update, :proposition_id => vote.proposition.id, :id => vote.id
      assert_redirected_to vote.proposition
    end

    should "be able to destroy vote" do
      vote = Factory.create(:vote)
      delete :destroy, :proposition_id => vote.proposition.id, :id => vote.id
      assert_redirected_to vote.proposition
      assert !Vote.exists?(vote.id)
    end
  end
  
  context "authenticated as user" do
    setup do
      authenticate_as_user
    end
    
    should "view new vote form" do
      get :new, :proposition_id => Factory.create(:proposition).id
      assert_template ''
    end
    
    should "see error when creating invalid vote" do
      proposition = Factory.create(:proposition)
      Vote.any_instance.stubs(:valid?).returns(false)
      post :create, :proposition_id => proposition.id
      assert_template 'new'
    end
    
    should "be able to create valid vote" do
      proposition = Factory.create(:proposition)
      Vote.any_instance.stubs(:valid?).returns(true)
      post :create, :proposition_id => proposition.id, :vote => {:agree => 1}, :format => 'html'
      assert_nil flash[:error]
      assert_equal "Voto contabilizado",flash[:notice]
      assert_redirected_to proposition_votes_url(proposition)
    end
  end
end
