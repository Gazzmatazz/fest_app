# Rather than create sample users through our web browser one by one, 
# here we use Ruby (and Rake) to make the users for us through use of the 'Faker' gem

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
      # ensures the Rake task has access to local Rails environment, incl. User model 
    make_users
    make_userposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Admin User",
                       email:    "admin@email.com",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@email.com"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

# create 40 sample posts by a user (limit to first 6 users in User.all)
# using Faker gem’s method Lorem.sentence
def make_userposts
  users = User.all(limit: 6)
  40.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.userposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..40]     # 1st user follows users 3 to 41
  followers      = users[3..20]     # 1st user followed_by users 4 to 21
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end


# to generate new sample data we have to run these Rake tasks:
# bundle exec rake db:reset
# bundle exec rake db:populate
# bundle exec rake db:test:prepare

