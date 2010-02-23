class ChangeVerifiedForActiveInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :verified, :active
  end

  def self.down
    rename_column :users, :active, :verified
  end
end
