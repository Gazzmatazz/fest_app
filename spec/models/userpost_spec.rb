require 'spec_helper'

describe Userpost do

  let(:user) { FactoryGirl.create(:user) }
  before { @userpost = user.userposts.build(content: "Lorem ipsum") }
  # instead of: @userpost = Userpost.new(content: "Lorem ipsum", user_id: user.id)
  # we can do this by creating association relationships between user and userpost models
  # The variable will automatically have user_id equal to its associated user.

  subject { @userpost }

  # get these tests to pass with presence validation in models/userpost.rb
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  # with the user/userpost association we can use also userpost.user to identify a post's user...
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @userpost.user_id = nil }
    it { should_not be_valid }
  end


  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Userpost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "with blank content" do
    before { @userpost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @userpost.content = "a" * 141 }
    it { should_not be_valid }
  end

end
