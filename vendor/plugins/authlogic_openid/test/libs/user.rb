class User < ActiveRecord::Base
  acts_as_authentic
  
  protected
  
  def before_validation_on_create
    self.role = 'user'
  end
end