# Rather than create sample users through our web browser one by one, 
# this uses Ruby (and Rake) to make the users through use of the 'Faker' gem

# also check Railscast tutorial:
# http://railscasts.com/episodes/126-populating-a-database

# Need to write code to populate Profile attributes before re-using this file

namespace :db do
  # db can now be user in command line, e.g.  bundle exec rake db:reset
  desc "Fill database with sample data"
  task populate: :environment do
      # ensures the Rake task has access to local Rails environment, incl. User model 

  #  make_admin
  #  make_users
    make_userposts
  #    make_relationships
  end
end

def make_admin
  admin = User.create!(name:     "Polar Bear",
                       email:    "rudrowe@yahoo.com",
                       password: "foobar",
                       password_confirmation: "foobar"
                        )
  admin.toggle!(:admin)

 # admin.profile = Profile.create!(
 #                       city:     "Dublin",
 #                       music:    "Alternaitve Rock, Electro, 80s",
 #                       about_me: "Coomander in Chief",
 #                       relationship_status: "Single",
 #                       gender: "Male")

end         

def make_users
   40.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@email.com"
      password  = "password"
      User.create!(name:     name,
                         email:    email,
                         password: password,
                         password_confirmation: password)

   #  user.profile.update_attributes!(
   #                     city:     "Dublin"
   #                     music:    "Alternaitve Rock, Electro, 80s"
   #                     about_me: "Coomander in Chief"
   #                     relationship_status: "Single"
   #                     gender: "Male")
   end
end


          # create 15 sample posts by a user (limit to first 6 users in User.all)
          # using Faker gem’s method Lorem.sentence
def make_userposts
  users = User.all(limit: 6)
  40.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.userposts.create!(content: content) }
  end
end

          # could also add code to create associated User profiles
          # user.profile....
          # gender, relationship_status, birthdate, city, music, about_me
          # music_content = Faker::Lorem.sentence(5)
          # about_me_content = Faker::Lorem.sentence(5)


def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..30]     # 1st user follows users 3 to 31
  followers      = users[3..10]     # 1st user followed_by users 4 to 11
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end


        # to generate new sample data we have to run these Rake tasks:
        # bundle exec rake db:reset
        # bundle exec rake db:populate
        # bundle exec rake db:test:prepare

