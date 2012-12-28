require 'spec_helper'

describe "Userpost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "userpost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a userpost" do
        expect { click_button "Post" }.not_to change(Userpost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'userpost_content', with: "Lorem ipsum" }
      it "should create a userpost" do
        expect { click_button "Post" }.to change(Userpost, :count).by(1)
      end
    end
  end
end