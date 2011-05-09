require 'test_helper'

class PropositionTest < ActiveSupport::TestCase

  should belong_to :user


  #State test methods
  should "be initialized in proposed state" do
    p = Factory.create(:proposition)

    assert p.proposed?
    assert_equal p.state, 'proposed'
  end

  should "pass to vote state on promotion" do
    p = Factory.create(:proposition)
    p.promote!

    assert p.to_vote?
    assert_equal p.state, 'to_vote'
  end

  should "be rejected if has more or equal no votes than yes votes at the of voting" do
    p = Factory.create(:proposition)
    p.promote!
    p.yes_count = 6
    p.no_count = 6
    p.end_voting!

    assert_equal p.state, 'rejected'
  end
  
  should "be approved if has more yes votes than no votes at the end of voting" do
    p = Factory.create(:proposition)
    p.promote!
    p.yes_count = 7
    p.no_count = 6
    p.end_voting!

    assert_equal p.state, 'approved'
  end

  should "update voting_end_at field on promotion" do
    p = Factory.create(:proposition)
    assert_nil p.end_voting_at
    p.interest = 1000
    p.save!
    assert_not_nil p.end_voting_at
  end


  should "select approved and rejected propositions" do
    approved1 = Factory.create(:proposition, :state => 'approved', :yes_count => 100, :no_count => 20)
    approved2 = Factory.create(:proposition, :state => 'approved', :yes_count => 100, :no_count => 20)
    to_vote = Factory.create(:proposition, :state => 'to_vote', :yes_count => 100, :no_count => 20)
    rejected1 = Factory.create(:proposition, :state => 'rejected', :yes_count => 10, :no_count => 200)

    approved = Proposition.approved
    assert_equal 2, approved.size
    assert approved.include?(approved1)
    assert approved.include?(approved2)

    rejected = Proposition.rejected
    assert_equal 1, rejected.size
    assert rejected.include?(rejected1)

  end

  should "select approved by senate" do
    approved = Factory.create(:proposition, :state => 'approved', :senators_yes_count => 20, :senators_no_count => 15)
    rejected = Factory.create(:proposition, :state => 'rejected', :senators_yes_count => 10, :senators_no_count => 15)
    to_vote = Factory.create(:proposition, :state => 'to_vote', :senators_yes_count => 20, :senators_no_count => 15)

    approved_by_senate = Proposition.approved_by_senate
    assert_equal 1, approved_by_senate.size
    assert approved_by_senate.include?(approved)
    assert !approved_by_senate.include?(rejected)
  end 

  should "destroy all comments and rating belonging to de proposition when it is destroyed" do
    p = Factory.create(:proposition)

    rating = Factory.create(:rating, :rateable => p)
    comment = Factory.create(:comment, :proposition => p)
    rating2 = Factory.create(:rating, :rateable => comment)

    assert_equal 1, p.ratings.count
    assert_equal 1, p.comments.count
    assert_equal 1, comment.ratings.count

    p.destroy

    assert_raise ActiveRecord::RecordNotFound do
      Rating.find(rating.id)
    end
    assert_raise ActiveRecord::RecordNotFound do
     Comment.find(comment.id)
    end
    assert_raise ActiveRecord::RecordNotFound do
      Rating.find(rating2.id)
    end
  end

end
