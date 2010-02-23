require 'test_helper'

class FactoriesTest < ActiveSupport::TestCase
  
  context "Defined factories" do
    should "create valid admin" do
      admin = Factory.create(:admin)
      assert admin.valid?
    end
    
    should "create valid users" do
      user = Factory.create(:user)
      assert user.valid?
    end
    
    should "create valid propositions" do
      proposition = Factory.create(:proposition)
      assert proposition.valid?
    end
    
    should "create valid announcements" do
      announcement = Factory.create(:announcement)
      assert announcement.valid?
    end
    
    should "create valid votes" do
      vote = Factory.create(:vote)
      assert vote.valid?
    end
    
    should "create valid ratings" do
      3.times do
        rating = Factory.create(:rating)
        assert rating.valid?
      end
    end
    
  end
  
end