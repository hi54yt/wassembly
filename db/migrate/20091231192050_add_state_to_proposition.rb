class AddStateToProposition < ActiveRecord::Migration
  def self.up
    add_column :propositions, :state, :string, :null => false
  end

  def self.down
    remove_column :propositions, :state
  end
end
