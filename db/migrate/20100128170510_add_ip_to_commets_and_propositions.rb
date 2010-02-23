class AddIpToCommetsAndPropositions < ActiveRecord::Migration
  def self.up
    add_column :comments, :ip, :string, :null => false
    add_column :propositions, :ip, :string, :null => false
    add_column :votes, :ip, :string, :null => false
    add_column :ratings, :ip, :string, :null => false
  end

  def self.down
    remove_column :comments, :ip
    remove_column :propositions, :ip
    remove_column :votes, :ip
    remove_column :ratings, :ip
  end
end
