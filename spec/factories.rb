FactoryGirl.define do

# For the User model tests, we need to construct test users and associated userposts 

  # factory for user
  factory :user do
  	# arrange for a sequence of names and emails using the sequence method
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
        # use FactoryGirl.create(:admin) to create an administrative user in tests
    end
  end

  # factory for userposts
  factory :userpost do
    content "Lorem ipsum"
    user    # this creates the association needed between user and userposts in our Factory Girl tests 
  end

end

# With these definitions we can create a User factory in the tests 
# using the let command and the FactoryGirl method,e.g.
# let(:user) { FactoryGirl.create(:user) }

# or to create factory userposts:
# FactoryGirl.create(:userpost, user: @user, created_at: 1.day.ago)

