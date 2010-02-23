class AddVotesCountToPropositions < ActiveRecord::Migration
  def self.up
    add_column :propositions, :votes_count, :integer, :null => false, :default => 0
    add_column :propositions, :yes_count, :integer, :null => false, :default => 0
    add_column :propositions, :no_count, :integer, :null => false, :default => 0
    
    Proposition.reset_column_information  
    Proposition.all.each do |p|  
      p.update_attribute :votes_count, p.votes.length
      p.update_attribute :yes_count, p.votes.count(:conditions => "agree = 1")
      p.update_attribute :yes_count, p.votes.count(:conditions => "agree = 0")
    end
    
  end

  def self.down
    remove_column :propositions, :votes_count
    remove_column :propositions, :yes_count
    remove_column :propositions, :no_count
  end
end
