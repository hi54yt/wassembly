class Comment < ActiveRecord::Base
  acts_as_rateable
  
  belongs_to  :proposition, :counter_cache => true
  belongs_to  :user
  
  has_many  :ratings, :as => :rateable, :dependent => :destroy
  
  attr_accessible :user_id, :proposition_id, :body, :ip
  validates_presence_of :user_id, :proposition_id, :body, :ip
  
  named_scope :recent, :conditions => ["created_at >= ?", 2.days.ago]
  named_scope :limited, lambda { |num| { :limit => num } }
  named_scope :best, :order => 'interest DESC'
  named_scope :with_users, :include => :user
  
end
