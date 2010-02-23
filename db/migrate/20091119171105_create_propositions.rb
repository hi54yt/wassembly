class CreatePropositions < ActiveRecord::Migration
  def self.up
    create_table :propositions do |t|
      t.string :title, :null => false
      t.text :body, :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :propositions
  end
end
