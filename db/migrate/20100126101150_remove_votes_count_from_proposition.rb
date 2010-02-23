class RemoveVotesCountFromProposition < ActiveRecord::Migration
  def self.up
    remove_column :propositions, :votes_count
  end

  def self.down
    add_column :propositions, :votes_count, :integer  
    Proposition.all.each do |p|
      p.votes_count = p.yes_count + p.no_count
    end
  end
end
