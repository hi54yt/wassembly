class Vote < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :proposition
  
  attr_accessible :proposition_id, :agree, :ip
  
  validates_presence_of :user_id, :ip
  validates_uniqueness_of :user_id, :scope => :proposition_id
  
  before_validation :set_vote_creator_attributes
  after_save :update_votes_count
  
  def proposition_html_id
    "proposition#{proposition.id}"
  end
  
  def proposition_ratings_html_id
    "#{proposition_html_id}_ratings"
  end
  
  protected
  
  def set_vote_creator_attributes
    self.from_senator = 1 if self.user.senator?
    self.from_identity_verified = 1 if self.user.identity_verified?
  end
  
  def update_votes_count
    p = self.proposition
    p.update_attribute :yes_count, p.votes.count(:conditions => "agree = 1") if self.agree
    p.update_attribute :no_count, p.votes.count(:conditions => "agree = 0") if !self.agree
    
    if self.from_senator?
      p.update_attribute :senators_yes_count, p.votes.count(:conditions => "agree = 1 AND from_senator = 1") if self.agree
      p.update_attribute :senators_no_count, p.votes.count(:conditions => "agree = 0 AND from_senator = 1") if !self.agree
    end
    
    if self.from_identity_verified?
      p.update_attribute :identity_verified_yes_count, p.votes.count(:conditions => "agree = 1 AND from_identity_verified = 1") if self.agree
      p.update_attribute :identity_verified_no_count, p.votes.count(:conditions => "agree = 0 AND from_identity_verified = 1") if !self.agree
    end
      
    p.save!
  end
end
