class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id, :null => false
      t.integer :proposition_id, :null => false
      t.text :body, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :comments
  end
end
