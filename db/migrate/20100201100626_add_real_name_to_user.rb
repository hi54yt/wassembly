class AddRealNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :show_real_name, :boolean, :null => false, :default => 1
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_surname
    remove_column :users, :show_real_name
  end
end
