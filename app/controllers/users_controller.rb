class UsersController < ApplicationController

  def show
  	    @user = User.find(params[:id])
  	    # params[:id] will return the user id
  	    # the instance variable @user will then be used in view file
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

end
