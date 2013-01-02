# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end
  # creates a new @user instance variable using User.new 
  # and a valid initialization hash

  subject { @user }
  # makes @user the default subject of the test example ("it")

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }  
  it { should respond_to(:userposts) }

  # equivalent to code:   @user.should respond_to(:name)
  # Ruby method respond_to?, which accepts a symbol and returns 
  # true if the object responds to the given method or attribute

  it { should be_valid }
  it { should_not be_admin }

  it { should respond_to(:relationships) }
  # test for the user.followed_users attribute...
  it { should respond_to(:followed_users) }

  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  # defintions for following?, follow! and unfollow! in models/user.rb
  it { should respond_to(:following?) }
  # users should be able to follow another user...
  it { should respond_to(:follow!) }
  # users should be able to unfollow other users...
  it { should respond_to(:unfollow!) }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
      # toggle! method flips the admin attribute from false to true.
    end

    it { should be_admin }
  end

  # set the user’s name to an invalid (blank) value, and 
  # then test to see that the resulting @user object is invalid
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  # test string for username is not greater than 40 characters
  describe "when name is too long" do
    before { @user.name = "a" * 41 }
    it { should_not be_valid }
  end

  #  %w[] used for making arrays of strings
  # check with a list of invalid email formats
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  # check with a list of valid email formats
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  # for uniqueness tests we need to save a record into the database
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end

  # test the presence validation by setting both 
  # the password and its confirmation to a blank string
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # minor bug in Rails, when password confirmtation is nil in console
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

 # as a security precaution, test for a length validation on passwords, 
 # requiring that they be at least six characters long:
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end



  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    # The before block saves the user to the database so that 
    # it can be retrieved using find_by_email

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
      # If the password matches the user’s password, 'authenticate'
      # should return the user; otherwise, it should return false.
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
      # the 'specify' method is just a synonym for 'it'
    end

    describe "remember token" do
    before { @user.save }  # a callback method to create the remember token
    its(:remember_token) { should_not be_blank }
    # equivalent to: it { @user.remember_token.should_not be_blank }
    # the 'its' method is like 'it' but applies the subsequent test to the given attribute rather than the subject of the test
    end
  
  end    # end "return value of authenticate method"


  # Test the order of a user’s posts
  describe "userpost associations" do

    before { @user.save }
    let!(:older_userpost) do         
      FactoryGirl.create(:userpost, user: @user, created_at: 1.day.ago)
      # let variables only spring into existence when referenced, not when defined 
      # let! ("bang") method creates them and their timestamps immediately
    end
    let!(:newer_userpost) do
      FactoryGirl.create(:userpost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right userposts in the right order" do
      @user.userposts.should == [newer_userpost, older_userpost]
      # i.e. posts should be ordered newest first
    end

    it "should destroy associated userposts" do
      userposts = @user.userposts.dup   # need .dup as normal array copies only point to array
      @user.destroy
      userposts.should_not be_empty   # safety check to catch any errors should the dup ever be accidentally removed
      userposts.each do |userpost|
        Userpost.find_by_id(userpost.id).should be_nil   
        # Userpost.find_by_id  returns nil if the record is not found
      end
    end

  end   # end "userpost associations"


  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }    
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      # switch subjects using the subject method, replacing @user with other_user
      # to test follower relationship
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end



  end

end
