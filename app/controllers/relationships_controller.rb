class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    
    # rather than redirect_to @user
    # respond to Ajax requests, Rails will call create.js.erb here.
    # This will allow us navigate to a user profile page and follow 
    # and unfollow without the need of a page refresh
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      # only one of these lines gets executed (based on the nature of the request).
    end
  end


  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end