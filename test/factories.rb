require "authlogic/test_case"

Factory.define :user do |u|
  u.sequence(:username) { |n| "paco#{n}"}
  u.sequence(:email) { |n| "paco#{n}@wasamblea.org"}
  u.first_name 'Paco'
  u.last_name 'User'
  u.password 'secret'
  u.password_confirmation 'secret'
  u.perishable_token '6cde0674657a8a313ce952df979de2830309aa4c11ca65805dd00bfdc65dbcc2f5e36718660a1d2e68c1a08c276d996763985d2f06fd3d076eb7bc4d97b1e317'
  u.role 'user'
  u.active true
  u.eid { |n| "secret#{n}"}
end

Factory.define :admin, :class => User do |u|
    u.sequence(:username) { |n| "admin#{n}"}
    u.sequence(:email) { |n| "admin#{n}@wasamblea.org"}
    u.first_name 'Admin'
    u.password 'secret'
    u.password_confirmation 'secret'
    u.perishable_token '6cde0674657a8a313ce952df979de2830309aa4c11ca65805dd00bfdc65dbcc2f5e36718660a1d2e68c1a08c276d996763985d2f06fd3d076eb7bc4d97b1e317'
    u.role 'admin'
    u.active true
    u.eid { |n| "supersecret#{n}"}
end

Factory.define :proposition do |p|
  p.association :user
  p.sequence(:title) { |n| "Test proposition #{n}"}
  p.body "#Lorem Ipsum\n\nFirst paragraph.\n\nSecond paragraph."
  p.state "proposed"
  p.ip "192.168.0.1"   
end

Factory.define :comment do |c|
  c.association :user
  c.association :proposition
  c.sequence(:body) {|n| "Comment body #{n}\n\nThis is the second paragraph"}
  c.ip "192.168.0.1"
end

Factory.define :rating do |r|
  r.association :rater, :factory => :user
  r.association :rateable, :factory => :proposition
  r.value 1
  r.ip "192.168.0.1"
end

Factory.define :vote do |v|
  v.association :user
  v.association :proposition
  v.agree 1
  v.ip "192.168.0.1"
end

Factory.define :announcement do |a|
  a.message "This is a test proposition"
  a.starts_at 2.days.ago
  a.ends_at 2.days.from_now
end

Factory.define :page do |p|
  p.title "The page title"
  p.sequence(:permalink){|n| "apage#{n}"} 
  p.content "#The page content\n\n This is *very* important"
end

Factory.define :logged_exception do |ex|
  ex.exception_class 'TestException'
  ex.controller_name 'VeryBadController'
  ex.action_name 'dont_do_that'
  ex.message 'booooom'
  ex.backtrace "This shouldn't happen"
  ex.environment "Hal9000 running windows 3.1"
  ex.request "tell my why"
  ex.created_at Time.now
end


