require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      # tests for a div tag with the classes "alert" and "alert-error"
      # i.e. <div class="alert alert-error">Invalid...</div>

      describe "after visiting another page" do
      before { click_link "Home" }
      it { should_not have_selector('div.alert.alert-error') }
      end
      
    end


    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }   # test helper to sign users in

      it { should have_selector('title', text: user.name) }
      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }
      # a valid log-in renders the user's profile page and makes changes
      # to the navigation links - profile, sign-out instead of sign-in 
      # The have_link method takes as arguments the text of the link 
      # and an optional :href parameter

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end

    end    
  end  


  describe "authorization" do

    # verify that non-signed-in users accessing edit or update are sent to the signin page
    # same again for non-signed-in users tryng to create a post
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          # user should be redirected to intended target (edit page) after signing in
            describe "after signing in" do

              it "should render the desired protected page" do
                 page.should have_selector('title', text: 'Edit user')
              end
            end
        end     # end "when attempting to visit a protected page"


        describe "in the Users controller" do

          describe "visiting the edit page" do
            before { visit edit_user_path(user) }
            it { should have_selector('title', text: 'Sign in') }
          end

          describe "submitting to the update action" do
            before { put user_path(user) }
            # issues a http put request to the user page, another way
            # from Capybara’s visit method, to access a controller action
            specify { response.should redirect_to(signin_path) }
          end

          # index action to view all users is only visible to logged in users
          # Add index to list of actions protected by the signed_in_user before filter
          describe "visiting the user index" do
            before { visit users_path }
            it { should have_selector('title', text: 'Sign in') }
          end
        end   # end "in the Users controller"


        describe "in the Userposts controller" do

          describe "submitting to the create action" do
            before { post userposts_path }
            specify { response.should redirect_to(signin_path) }
          end

          describe "submitting to the destroy action" do
            before { delete userpost_path(FactoryGirl.create(:userpost)) }
            specify { response.should redirect_to(signin_path) }
          end
        end
    end     # end "for non-signed-in users"


    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end     # end "as wrong user"

    # Test for protecting the destroy action...
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end     # end "as non-admin user"

  end       # end "authorization" 
end         # end "Authentication"
