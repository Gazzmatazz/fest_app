class SessionsController < ApplicationController

  def new
  end


  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user       # function sign_in
      redirect_to user

    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
      # instead of flash we use flash.now, so its contents disappear as 
      # soon as there is an additional page request
    end
  end

  def destroy
    sign_out        # Sessions helper module
    redirect_to root_url
  end
	
end
