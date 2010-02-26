Then(/an email should be sent to (.*)$/) do |address|
  email = ActionMailer::Base.deliveries.last
  assert_equal address, email.to.first
end