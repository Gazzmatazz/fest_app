class SessionsController < ApplicationController

  def new
  end


  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the requested page.
      sign_in user       # function sign_in (in sessions_helper)
      redirect_back_or user    # redirect to requested page or default 
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
