require 'nokogiri'
require 'rdiscount'

class Proposition < ActiveRecord::Base
  acts_as_rateable

  attr_accessible :title, :body

  has_many  :votes, :dependent => :destroy
  has_many  :comments, :dependent => :destroy
  has_many  :ratings, :as => :rateable, :dependent => :destroy
  belongs_to  :user

  before_validation :create_summary!
  after_save :promote_if_interesting!

  #validations
  validates_presence_of :title, :body, :summary, :user, :state, :ip
  validates_uniqueness_of :title
  validates_numericality_of :user_id
  validates_length_of :title, :maximum=>80

  #named scopes
  named_scope :limited, lambda { |num| { :limit => num } }
  named_scope :to_vote, :conditions => { :state => 'to_vote'}, :order => 'created_at DESC'
  named_scope :latest_proposed, :conditions => { :state => 'proposed'}, :order => 'created_at DESC'
  named_scope :approved, :conditions => { :state => 'approved'}, :order => 'created_at DESC'
  named_scope :rejected, :conditions => { :state => 'rejected'}, :order => 'created_at DESC'
  named_scope :approved_by_senate, :conditions => ["state = 'approved' OR state = 'rejected' AND senators_yes_count > senators_no_count"], :order => 'created_at DESC', :include => :user
  named_scope :approved_by_verified_users, :conditions => ["state = 'ended' AND identity_verified_yes_count > identity_verified_no_count"], :order => 'created_at DESC', :include => :user
  named_scope :recent, :conditions => ["created_at >= ?", 10.weeks.ago]
  named_scope :most_voted, :conditions => { :state => 'to_vote'}, :order => '(yes_count + no_count) DESC'
  named_scope :with_users, :include => :user

  #Virtual attributes
  def votes_count
    yes_count + no_count
  end

  def yes_percent
    (100*yes_count.to_f/votes_count).round
  end

  def no_percent
    (100*no_count.to_f/votes_count).round
  end

  def senators_votes_count
    senators_yes_count + senators_no_count
  end

  def senators_yes_percent
    (100*senators_yes_count.to_f/senators_votes_count).round
  end

  def senators_no_percent
    (100*senators_no_count.to_f/senators_votes_count).round
  end

  def identity_verified_votes_count
    identity_verified_yes_count + identity_verified_no_count
  end

  def identity_verified_yes_percent
    (100*identity_verified_yes_count.to_f/identity_verified_votes_count).round
  end

  def identity_verified_no_percent
    (100*identity_verified_no_count.to_f/identity_verified_votes_count).round
  end

  #Summary creation
  def create_summary!
    html = RDiscount.new(self.body, :smart, :filter_html).to_html
    doc = Nokogiri::HTML(html)
    first_paragraph = doc.at_css("p")
    self.summary = first_paragraph.to_html unless first_paragraph.nil? || first_paragraph.to_html.blank?
  end

  def promote_if_interesting!
    if state == 'proposed' && interest >= APP_CONFIG['interest_threshold']
      promote!
    end
  end

  def to_param
    "#{id}-#{title.gsub(/\b\w{1,3}\b/,"").parameterize}" #Don't show words with less than 3 letters
  end
  
  def promote!
    self.state = 'to_vote'
    self.end_voting_at = 4.weeks.from_now
    self.send_at(self.end_voting_at, :end_voting!)
    save!
  end
  
  def end_voting!
    if yes_count > no_count
      self.state = 'approved'
    else
      self.state = 'rejected'
    end
    save!
  end

  def proposed?
    self.state == 'proposed'
  end

  def to_vote?
    self.state == 'to_vote'
  end

end
