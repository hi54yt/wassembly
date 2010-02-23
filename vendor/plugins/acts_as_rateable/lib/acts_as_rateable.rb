# ActsAsRateable
module ActsAsRateable
  
  # any method placed here will apply to classes, like Hickwall
  def acts_as_rateable
    send :include, InstanceMethods
  end
  
  def best_rated(max)
    puts "Searching #{max} best rated #{self.table_name}"
  end
  
  def most_rated(max)
    puts "Searching #{max} most rated #{self.table_name}"
  end
 
  module InstanceMethods
    
    # any method placed here will apply to instances
    def rate(user, rating)
      puts "User #{user} rates #{self} with #{rating}"
    end
    
    def rating_for_user(user)
      ratings.detect {|r| r.rater_id == user.id }
    end
    
    def total_rating
    end
    
    def average_rating
    end
    
  end
end

class ActiveRecord::Base
  extend ActsAsRateable
end

