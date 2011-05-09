class Rating < ActiveRecord::Base

  scope :with_rater,   lambda { |rater_id| where("rater_id = ? ", rater_id) }
  scope :for_rateable, lambda { |rateable|  where("rateable_id = ? AND rateable_type = ?", rateable.id, rateable.type.name) }
  scope :recent,       lambda { where("created_at > ?", (args.first || 2.weeks.ago) )}
  scope :descending, order("created_at DESC")

  # NOTE: Votes belong to the "rateable" interface, and also to raters
  belongs_to :rateable, :polymorphic => true, :touch => true
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable_owner, :class_name => "User"
  
  attr_accessible :value, :rateable_id, :rateable_type
  validates_presence_of :rater_id, :rateable_id, :rateable_type, :rateable_owner_id, :value
  validates_uniqueness_of :rateable_id, :scope => [:rateable_type, :rater_id]
  validates_numericality_of :value, :greater_than_or_equal_to => -5, :less_than_or_equal_to => 10
  
  after_save :update_rateable_interest, :update_rateable_owner_karma
  before_validation :set_rateable_owner_id, :set_value_with_affinity
  
  
  def rateable_html_name
    "#{self.rateable_type.underscore}"
  end
  
  def rateable_html_id
    "#{rateable_html_name}#{self.rateable_id}"
  end
  
  def rating_html_id
    "#{rateable_html_id}_rating"
  end
  
  private
  
  def set_rateable_owner_id
    self.rateable_owner_id = rateable.user.id unless rateable.nil?
  end
  
  def update_rateable_interest
    return unless rateable.respond_to? :interest
    rateable.class.update_counters(self.rateable_id, :interest => value)
  end
  
  def update_rateable_owner_karma
    return unless rateable_owner.respond_to? :karma
    User.update_counters(self.rateable_owner_id, :karma => value)
  end
  
  private
  
  # returns the rating value taking into account the affinity between rater and rateable owner
  def set_value_with_affinity
    return @value_with_affinity if @value_with_affinity
    @value_with_affinity = self.value
    @value_with_affinity = @value_with_affinity * (1.0 - self.send(:calculate_affinity))
    @value_with_affinity = @value_with_affinity > 0 ? @value_with_affinity.ceil : @value_with_affinity.floor
    self.value = @value_with_affinity
  end
  
  def calculate_affinity
    return self.affinity unless self.affinity.nil?
    num_ratings = self.rater.recent_ratings_for(self.rateable_owner) #also counts current rating 
    self.affinity = num_ratings*0.05
    self.affinity = 1 if affinity > 1
    self.affinity
  end
end