# Rather than create sample users through our web browser one by one, 
# here we use Ruby (and Rake) to make the users for us through use of the 'Faker' gem

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  # ensures that the Rake task has access to the local Rails environment, including the User model 

    admin = User.create!(name:        "Example Admin",
                         email:       "admin@email.com",
                         password:    "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)

    User.create!(name: "Example User",
                 email: "example@email.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@email.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    # create 20 sample posts by a user (limit to first 6 users in User.all)
    # using Faker gem’s method Lorem.sentence
    users = User.all(limit: 6)
    20.times do
      content = Faker::Lorem.sentence(5)       # returns lorem ipsum text
      users.each { |user| user.userposts.create!(content: content) }
    end

  end
end

# to generate new sample data we have to run these Rake tasks:
# bundle exec rake db:reset
# bundle exec rake db:populate
# bundle exec rake db:test:prepare

