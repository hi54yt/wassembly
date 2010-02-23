class CreateLoggedExceptions < ActiveRecord::Migration
  def self.up
    create_table :logged_exceptions do |t|
      t.string :exception_class
      t.string :controller_name
      t.string :action_name
      t.text :message
      t.text :backtrace
      t.text :environment
      t.text :request
      t.datetime :created_at
    end
  end
  
  def self.down
    drop_table :logged_exceptions
  end
end
