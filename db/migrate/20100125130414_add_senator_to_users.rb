class AddSenatorToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :senator, :boolean, :default => 0, :null => false
  end

  def self.down
    remove_column :users, :senator
  end
end
