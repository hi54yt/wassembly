class AddInterestToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :interest, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :comments, :interest
  end
end
