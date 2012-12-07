FactoryGirl.define do
  factory :user do
    name     "Garrett Carr"
    email    "gcarr@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end

# With this definition we can create a User factory in the tests 
# using the let command and the FactoryGirl method:
# let(:user) { FactoryGirl.create(:user) }