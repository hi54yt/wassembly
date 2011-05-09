class Announcement < ActiveRecord::Base
  def self.current_announcements(hide_time)
    if hide_time
      where("starts_at <= now() AND ends_at >= now()")
    else
      where("starts_at > ?", hide_time)
    end
  end
end
