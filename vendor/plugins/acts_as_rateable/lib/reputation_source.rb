# ActsAsRateable
module ActsAsRateable
  # any method placed here will apply to classes, like Hickwall
  def reputation_source
    send :include, InstanceMethods
  end
 
  module InstanceMethods
    # any method placed here will apply to instances, like @hickwall
  end
end