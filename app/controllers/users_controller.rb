class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  # Before the given actions, call method to require users to be signed in
  # Restrict this filter to act only on the specified actions
  
  before_filter :correct_user,   only: [:edit, :update]
  # users should only be allowed to edit their own information
  # correct_user defined below

  before_filter :admin_user,     only: :destroy
  # restrict access to the destroy action to admins, only admin can delete users

  def show
  	    @user = User.find(params[:id])
  	    # the instance variable @user will be used in view file

        @userposts = @user.userposts.paginate(page: params[:page], per_page: 10)
  end

  def index   
        @users = User.paginate(page: params[:page], per_page: 4)
  end

  def new
  	    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user            # sessions_helper method
      flash[:success] = "Account created!"
      redirect_to edit_profile_path(current_user)
      # the default behavior for a Rails action is to render the corresponding view
      # but here we want to redirect to invite the user to add their profile info.
    else
      render 'new'
      # if it doesn't save new user then stay on new view
    end

  end


  def edit
    # @user already defined by correct_user (defined below and called at before filter)
    # action goes straight to Edit view file passing in @user to the form
  end

  def update
    # updated values passed in from form on Edit view file
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user   # because the remember token gets reset when user is saved
      redirect_to @user
     else 
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  # Two additional actions/displays added... 
  # 1. Show who the user is 'following':
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
          # views/users/show_follow.html.erb
  end

  # 2. Show what 'followers' the user has
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end



  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
      # current_user? boolean method defined in the Sessions helper
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end