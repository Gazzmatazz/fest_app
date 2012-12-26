class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  # Before the given actions, call method to require users to be signed in
  # Restrict this filter to act only on the specified actions
  
  before_filter :correct_user,   only: [:edit, :update]
  # users should only be allowed to edit their own information

  before_filter :admin_user,     only: :destroy
  # restrict access to the destroy action to admins

  def show
  	    @user = User.find(params[:id])
  	    # params[:id] will return the user id
  	    # the instance variable @user will then be used in view file
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user            # sessions_helper method
      flash[:success] = "Welcome to Fest Mate!"
      redirect_to @user
      # the default behavior for a Rails action is to render the corresponding view
      # but here we want to redirect to the specific user profile
      # we can omit the user_url in the redirect, writing simply redirect_to @user to redirect to the user show page
    else
      render 'new'
      # if it doesn't save new user then stay on new view
    end
  end

  def edit
    # @user already defined by correct_user at before filter
  end

  def update
    # @user already defined by correct_user at before filter
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



  private

    def signed_in_user
      unless signed_in?
        store_location        # method in sessions_helper
        redirect_to signin_url, notice: "Please sign in."
      end
      # shortcut for setting flash[:notice] by passing an options hash to the redirect_to function
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
      # current_user? boolean method defined in the Sessions helper
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end