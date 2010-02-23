class AddCounterCommentColumnToPropositions < ActiveRecord::Migration
  def self.up
    add_column :propositions, :comments_count, :integer, :default => 0, :null => false
    
    Proposition.reset_column_information
    Proposition.find(:all).each do |p|
      p.update_attribute :comments_count, p.comments.length
      puts "Comments legngth: #{ p.comments.length}"
    end
  end

  def self.down
    remove_column :propositions, :comments_count
  end
end
