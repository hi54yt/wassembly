class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id, :null => false
      t.integer :proposition_id, :null => false
      t.boolean :agree, :default => 0, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :votes
  end
end
