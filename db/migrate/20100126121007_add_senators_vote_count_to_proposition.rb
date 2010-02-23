class AddSenatorsVoteCountToProposition < ActiveRecord::Migration
  def self.up
    add_column :propositions, :senators_yes_count, :integer, :default => 0, :null => false
    add_column :propositions, :senators_no_count, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :propositions, :senators_yes_count
  end
end
