class AddFromSenatorToVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :from_senator, :boolean, :default => 0, :null => false 
  end

  def self.down
    remove_column :votes, :from_senator
  end
end
