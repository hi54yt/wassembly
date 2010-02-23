class AddInterestToProposition < ActiveRecord::Migration
  def self.up
    add_column :propositions, :interest, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :propositions, :interest
  end
end
