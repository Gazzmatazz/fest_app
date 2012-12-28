class UserpostsController < ApplicationController

  before_filter :signed_in_user, only: [:create, :destroy]
  # signed_in_user method in sessions_helper.rb
  # restricting access to the create and destroy actions to signed in users only

  before_filter :correct_user,   only: :destroy
  # correct_user method defined below, checks user has a post with the given id
  
  def create
    @userpost = current_user.userposts.build(params[:userpost])
                # current_user.userposts uses the user/userpost association
    if @userpost.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @feed_items = []           # necessary as Home page expects an @feed_items instance variable
      render 'static_pages/home'
    end
  end

  def destroy
    @userpost.destroy
    redirect_to root_url
  end


  private

    # before filter, checks that current user has a userpost with the given id
    def correct_user
      @userpost = current_user.userposts.find_by_id(params[:id])
                  # finds userposts through the association of user/userposts
                  # Ensures we only find posts belonging to the current user
      redirect_to root_url if @userpost.nil?
    end

end
