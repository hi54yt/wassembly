class AddEidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :encrypted_eid, :string
    add_column :users, :identity_verified, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :identity_verified
    remove_column :users, :encrypted_eid
  end
end
