class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.text :message, :null => false
      t.datetime :starts_at, :null => false
      t.datetime :ends_at, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
