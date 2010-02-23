class AddVotingEndToPropositions < ActiveRecord::Migration
  def self.up
    add_column :propositions, :end_voting_at, :datetime
    
    Proposition.to_vote.each do |p|
      p.update_attribute :end_voting_at, 4.weeks.from_now
    end
    
  end

  def self.down
    remove_column :propositions, :end_voting_at
  end
end
