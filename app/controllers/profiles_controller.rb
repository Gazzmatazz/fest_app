class ProfilesController < ApplicationController

  before_filter :signed_in_user,  only: [:edit, :update]
  # signed_in_user method in sessions_helper.rb
  # restricting access to these actions to signed in users only

 before_filter :correct_user,   only: [:edit, :update]
  # users should only be allowed to edit their own information
  # correct_user defined below

  def index
  end

  

  def edit
  	# or something like current_user.profile(params[:userpost])   ??
    @user.profile ||= Profile.new
    @profile = @user.profile

  end


  def update
    # @profile.inspect
    if @user.profile.update_attributes(params[:profile])
       # Handle a successful update.
       flash[:success] = "Profile updated"
       sign_in @user   # because the remember token gets reset when user is saved
       redirect_to @user
    else
       render 'edit'
    end

  end


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
      # current_user? boolean method defined in the Sessions helper     
    end

end
