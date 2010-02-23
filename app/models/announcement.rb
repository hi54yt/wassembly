class Announcement < ActiveRecord::Base
  def self.current_announcements(hide_time)
    with_scope :find => { :conditions => "starts_at <= now() AND ends_at >= now()" } do
      if hide_time.nil?
        find(:all)
      else
        find(:all, :conditions => ["starts_at > ?", hide_time, hide_time])
      end
    end
  end
end
