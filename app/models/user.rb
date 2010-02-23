# coding: utf-8
require 'digest/sha1'
class User < ActiveRecord::Base

  has_many  :votes
  
  attr_accessible :username, :email, :password, :password_confirmation, :first_name, :last_name, :show_real_name, :openid_identifier
  is_gravtastic!
  
  acts_as_authentic do |c|
    c.login_field = 'email'
    c.validate_login_field = false
    # optional, but if a user registers by openid, he should at least share his email-address with the app
    c.validate_email_field = false
    # fetch email by ax
    c.openid_required_fields = [:email,
                                "http://axschema.org/namePerson/friendly",
                                "http://axschema.org/contact/email", 
                                :nickname, 
                                "http://axschema.org/namePerson/first", 
                                "http://axschema.org/namePerson/last"]
  end
  
  ROLES = %w[admin user citizen]
  
  #validations
  validates_presence_of :username, :email, :role
  validates_uniqueness_of :username, :email
  validates_uniqueness_of :encrypted_eid, :allow_nil => true
  
  validates_format_of   :email, 
                        :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'l
                        a dirección de email debe ser válida'
  
  before_validation_on_create :set_default_role
  after_create :deliver_verification_instructions!                     
  
  def name
    [first_name, last_name].compact.join(' ')
  end
  
  def screen_name
    return name if username.blank? || (show_real_name && !name.blank?)
    username
  end

  def vote_for(proposition)
    votes.find(:first, :conditions => ["proposition_id = ? ", proposition.id])
  end
  
  def role?(a_role)
    self.role == a_role.to_s
  end
  
  def recent_ratings_for(other_user, num_days = 60)
    Rating.count(:conditions => ["rater_id = ? AND rateable_owner_id = ? AND created_at > ?", self.id, other_user.id, num_days.days.ago])
  end
  
  def deliver_verification_instructions!
    unless self.active?
      reset_perishable_token!  
      Notifier.deliver_verification_instructions(self)
    end  
  end
  
  def activate!
    self.active = true
    self.save
  end
  
  def eid 
    @eid
  end
  
  def eid=(eid) 
    @eid = eid
    return if eid.blank?
    self.encrypted_eid = User.encrypted_eid(eid)
  end
  
  protected
  
  def set_default_role
    self.role = 'user' if self.role.blank?
  end
  
  private
  
  def self.encrypted_eid(dnie) 
    string_to_hash = dnie + "pArtItuRa2"
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def map_openid_registration(registration)
    
    self.role = 'user'
    
    unless registration["email"].blank?
      self.email = registration["email"]
      self.active = true
    end
    
    if self.username.blank? && !registration["nickname"].blank?
      self.username = "#{registration["nickname"]}"
    end
    
    if self.username.blank? && registration["http://axschema.org/namePerson/friendly"]
      self.username = "#{registration["http://axschema.org/namePerson/friendly"]}"
    end
    
    self.first_name = "#{registration['http://axschema.org/namePerson/first']}"
    self.last_name = "#{registration['http://axschema.org/namePerson/last']}"
    
    if registration['http://axschema.org/contact/email'] && !registration['http://axschema.org/contact/email'].empty?
      self.email = registration['http://axschema.org/contact/email'].first
    end
    
    unless self.email.blank?
      self.active = true
    end
    
    if self.username.blank? && !self.email.blank?
      self.username = self.email.match(/(.*)@/)[1]
    end
    
  end
  
  def self.elect_senators
    transaction do
      update_all "senator = 0"
      update_all("senator = 1", nil, :order => 'karma DESC, created_at ASC', :limit => APP_CONFIG['senate_size'])
    end
  end
  
end
