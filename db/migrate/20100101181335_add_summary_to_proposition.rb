class AddSummaryToProposition < ActiveRecord::Migration
  def self.up
    add_column :propositions, :summary, :text, :null => false
  end

  def self.down
    remove_column :propositions, :summary, :text
  end
end
