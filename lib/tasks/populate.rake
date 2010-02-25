namespace :db do
  
  desc "Erase and fill database"
  task :populate => [:delete_data, :populate_ratings, :populate_votes] do
  end
  
  desc "delete all data in the database"
  task :delete_data => :environment do
    [User, Proposition, Rating, Vote, Comment].each(&:delete_all)
  end
  
  desc "Populate the database with some test users"
  task :populate_users => :environment do
    require 'faker'
    admin = User.new
    admin.username = 'admin'
    admin.email = 'admin@example.com'
    admin.password = 'secret'
    admin.password_confirmation = 'secret'
    admin.role = 'admin'
    admin.login_count = rand(5)
    admin.failed_login_count = rand(2)
    admin.show_real_name = 0
    admin.active = true
    admin.eid = "supersecret" + rand.to_s
    admin.save!
    
    40.times do |i|
      user = User.new
      user.username = Faker::Internet.user_name
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.email = Faker::Internet.email
      user.password = 'secret'
      user.password_confirmation = 'secret'
      user.active = true
      user.eid = "secret#{i}"+rand.to_s
      user.save!
    end
  end
  
  desc "Populate the databse with some test propositions"
  task :populate_propositions => :populate_users do
    70.times do
      proposition = Proposition.new
      user = User.find(:first, :order => 'rand()')
      proposition.user_id = user.id
      proposition.title = Faker::Lorem.words(7).join(' ').titleize
      body = Faker::Lorem.paragraphs
      proposition.body = body.join("\n\n")
      proposition.created_at = rand(30).hours.ago
      proposition.updated_at = proposition.created_at
      proposition.ip = "127.0.0.1"
      proposition.save!
    end
  end
  
  desc "Populate the databse with some test comments"
  task :populate_comments => :populate_propositions do
    1000.times do
      comment = Comment.new
      user = User.find(:first, :order => 'rand()')
      proposition = Proposition.find(:first, :order => 'rand()')
      comment.user_id = user.id
      comment.proposition_id = proposition.id
      comment.body = Faker::Lorem.sentences(2).join
      comment.created_at = rand(300).minutes.ago
      comment.updated_at = proposition.created_at
      comment.ip = "127.0.0.1"
      comment.save!
    end
  end
  
  desc "Populate the databse with some test ratings"
  task :populate_ratings => :populate_comments do
    users = User.find(:all, :order => 'rand()')
    users.each do |user|
      propositions = Proposition.find(:all, :order => 'rand()')
      10.times do
        rating = Rating.new
        proposition = propositions.pop
        rating.rateable_id = proposition.id
        rating.rateable_type = 'Proposition'
        rating.rater_id = user.id
        rating.rateable_owner_id = proposition.user_id
        if rand(3) > 0
          rating.value = 10
        else
          rating.value = -5
        end 
        rating.ip = "127.0.0.1"
        rating.save!
      end
    end
    
    users = User.find(:all, :order => 'rand()')
    users.each do |user|
      comments = Comment.find(:all, :order => 'rand()')
      20.times do
        rating = Rating.new
        comment = comments.pop
        rating.rateable_id = comment.id
        rating.rateable_type = 'Comment'
        rating.rater_id = user.id
        rating.value = 1 if rand(3) > 0
        rating.ip = "127.0.0.1"
        rating.save!
      end
    end
  end
  
  desc "Populate the databse with some test votes"
  task :populate_votes => :populate_comments do
    users = User.find(:all, :order => 'rand()')
    users.each do |user|
      propositions = Proposition.find(:all,:conditions => { :state => 'to_vote'}, :order => 'rand()')
      (0..propositions.length/2).each do
        vote = Vote.new
        proposition = propositions.pop
        vote.user_id = user.id
        vote.proposition_id = proposition.id
        vote.agree = rand(2)
        vote.ip = "127.0.0.1"
        vote.save!
      end
    end
  end
  
end