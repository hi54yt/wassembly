class AddUserIdToProposition < ActiveRecord::Migration
  def self.up
    add_column :propositions, :user_id, :integer, :null => false
  end

  def self.down
    remove_column :propositions, :user_id
  end
end
