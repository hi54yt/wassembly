class Page < ActiveRecord::Base
  attr_accessible :title, :permalink, :content
end
