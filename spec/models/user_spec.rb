# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  it { should respond_to(:authenticate) }  
  # equivalent to code:   @user.should respond_to(:name)
  # Ruby method respond_to?, which accepts a symbol and returns 
  # true if the object responds to the given method or attribute

  it { should be_valid }

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
  
  end


end
