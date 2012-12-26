FactoryGirl.define do
  factory :user do
  	# arrange for a sequence of names and emails using the sequence method
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
    # use FactoryGirl.create(:admin) to create an administrative user in tests

  end
end

# With this definition we can create a User factory in the tests 
# using the let command and the FactoryGirl method:
# let(:user) { FactoryGirl.create(:user) }