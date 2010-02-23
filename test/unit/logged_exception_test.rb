require 'test_helper'

class LoggedExceptionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert LoggedException.new.valid?
  end
end
