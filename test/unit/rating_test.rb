require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  should belong_to :rater
  should belong_to :rateable
  should belong_to :rateable_owner
  
  should "set a rateable owner before save" do
    rater = Factory(:user)
    proposition = Factory(:proposition)
    
    rating = Factory(:rating, :rater_id => rater.id, :rateable_id => proposition.id, :rateable_type => 'Proposition', :value => 1, :ip => '127.0.0.1')
    
    assert_not_nil rating.id 
    assert_equal proposition.user_id, rating.rateable_owner_id
  end
  
  should "update rateable interest after save" do
    p = Factory(:proposition) 
    assert_equal 0, p.interest
    
    3.times do
      Factory.create(:rating, :rateable_id => p.id, :rateable_type => 'Proposition', :value => 10)
    end
    
    p.reload
    assert_equal 30, p.interest
     
    3.times do
      Factory.create(:rating, :rateable_id => p.id, :rateable_type => 'Proposition', :value => -5)
    end
    
    p.reload
    assert_equal 15, p.interest
    
    6.times do
      Factory.create(:rating, :rateable_id => p.id, :rateable_type => 'Proposition', :value => -5)
    end
    
    p.reload
    assert_equal -15, p.interest
  end
  
  should "ensure one rater can only rate once" do
    rater = Factory(:user)
    p = Factory(:proposition)
    assert_equal 0, p.interest
    #We try to create 2 ratings for the same rateable and rater
    first_rating = Factory.create(:rating, :rater_id => rater.id, :rateable_id => p.id, :rateable_type => 'Proposition', :value => 10)    
    second_rating = Factory.build(:rating, :rater_id => rater.id, :rateable_id => p.id, :rateable_type => 'Proposition', :value => 10)
    
    assert second_rating.invalid?

  end
  
  should "save affinity with rating" do
     pepe_rater = Factory(:user, :username => 'Pepe')
     paco_rateable_owner = Factory(:user, :username => 'Paco')
     assert_equal 0, paco_rateable_owner.karma
  end
  
  should "update rateable owner karma" do
    pepe_rater = Factory(:user, :username => 'Pepe')
    paco_rateable_owner = Factory(:user, :username => 'Paco')
    
    assert_equal 0, paco_rateable_owner.karma
    
    Factory.create(:rating, :rater => pepe_rater, :rateable_owner => paco_rateable_owner, :value => 10, :created_at => Time.now)
    paco_rateable_owner.reload
    assert_equal 10, paco_rateable_owner.karma
    
    5.times do
      Factory.create(:rating, :rater => pepe_rater, :rateable_owner => paco_rateable_owner, :value => 10, :created_at => Time.now)
    end
    
    paco_rateable_owner.reload
    # seven ratings: 10 + 10 + 9 + 9 + 8 + 8 =  54    
    assert_equal 54, paco_rateable_owner.karma
    
    14.times do
      Factory.create(:rating, :rater => pepe_rater, :rateable_owner => paco_rateable_owner, :value => 10, :created_at => Time.now)
    end
    paco_rateable_owner.reload
    
    # 54 + 2*(7+6+5+4+3+2+1)= 54 + 56 = 110
    assert_equal 110, paco_rateable_owner.karma
    
    #More ratings should not increase the owner karma
    10.times do
      Factory.create(:rating, :rater => pepe_rater, :rateable_owner => paco_rateable_owner, :value => 10, :created_at => Time.now)
    end
    paco_rateable_owner.reload
    
    assert_equal 110, paco_rateable_owner.karma
    
  end  
end