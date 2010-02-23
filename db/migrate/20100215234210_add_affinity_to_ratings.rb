class AddAffinityToRatings < ActiveRecord::Migration
  def self.up
    add_column :ratings, :affinity, :float, :null => false
  end

  def self.down
    remove_column :ratings, :affinity
  end
end
