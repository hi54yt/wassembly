class AddFromIdentityVerifiedToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :from_identity_verified, :boolean, :default => 0
    add_column :propositions, :identity_verified_yes_count, :integer, :default => 0
    add_column :propositions, :identity_verified_no_count, :integer, :default => 0
  end

  def self.down
    remove_column :votes, :from_identity_verified
    remove_column :propositions, :identity_verified_yes_count
    remove_column :propositions, :identity_verified_no_count
  end
end
