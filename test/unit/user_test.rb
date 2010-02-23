require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  should_have_many :votes
  should_not_allow_values_for :email, "blah", "b lah"
  should_allow_values_for :email, "a@b.com", "asdf@asdf.com"
  
  should "save encrypted eid" do
    user = Factory.create(:user)
    user.eid= "DoReMiFaSol"
    user.save!
    assert !user.encrypted_eid.blank? 
  end
  
  should "assign the same encrypted eid to users with the same eid" do
    paco = Factory.build(:user, :eid =>"DoReMiFaSol")
    pepe = Factory.build(:user, :eid =>"DoReMiFaSol")
    assert_equal paco.encrypted_eid, pepe.encrypted_eid
  end
  
  should "not allow two users with the same eid" do
    paco = Factory.create(:user, :eid =>"DoReMiFaSol")
    pepe = Factory.build(:user, :eid =>"DoReMiFaSol")
    assert !pepe.valid?
  end
  
  should "give 0 recent ratings for users which have not rated each other" do
    pepe = Factory(:user)
    paco = Factory(:user)
    
    assert_equal 0, pepe.recent_ratings_for(paco)
    assert_equal 0, paco.recent_ratings_for(pepe)
  end
  
  should "increase recent ratings when a user rates other user" do
    pepe = Factory(:user)
    paco = Factory(:user)
    
    assert_equal 0, pepe.recent_ratings_for(paco)
    assert_equal 0, paco.recent_ratings_for(pepe)
    
    Factory.create(:rating, :rater => pepe, :rateable_owner => paco)
    assert_equal 1, pepe.recent_ratings_for(paco)
    
    17.times do
      Factory.create(:rating, :rater => pepe, :rateable_owner => paco)
    end
    
    assert_equal 18, pepe.recent_ratings_for(paco)
    
    #doesn't affect the rateable_owner
    assert_equal 0, paco.recent_ratings_for(pepe)
  end
  
  should "not count old ratings in recent ratings" do
    pepe = Factory(:user)
    paco = Factory(:user)
    
    Factory.create(:rating, :rater => pepe, :rateable_owner => paco, :created_at => 61.days.ago)
    assert_equal 0, pepe.recent_ratings_for(paco)
    assert_equal 1, pepe.recent_ratings_for(paco, 62)
  end
    
end
