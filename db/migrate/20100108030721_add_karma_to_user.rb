class AddKarmaToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :karma, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :users, :karma
  end
end
