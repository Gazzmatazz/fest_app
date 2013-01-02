module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user      # invokes the current_user= method
  end

# A user is signed in if there is a current user in the session, 
# i.e. if current_user is non-nil
  def signed_in?
    !current_user.nil?
  end

# this introduces the cookies utility supplied by Rails. 
# We can use cookies like it were a hash; each element in the cookie 
# is itself a hash of two elements - a VALUE and an optional expires DATE.

# The method 'permanent' causes Rails to set the expiration to 20.years.from_now

# current_user will be accessible in both controllers and views, 
# which will allow ruby code such as current_user.name
# Without 'self' Ruby would create a local variable called current_user.


  # method current_user= 
  # designed to handle assignment to current_user
  def current_user=(user)
    @current_user = user
  end

  # find the user corresponding to the remember token...
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  # ||= (“or equals”) assigns to a variable if it’s nil but otherwise leaves it.
  # Its effect is to set the @current_user instance variable to the user corresponding 
  # to the remember token, but only if @current_user is not yet undefined 

  #  current_user? boolean method
  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
      # shortcut for setting flash[:notice] by passing an options hash to the redirect_to function
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # to forward users to their intended destination after signing in, we store 
  # the location of the requested page, then redirect to that location
  # called in users_controller.rb
  def redirect_back_or(default)
    # redirect to the requested URI if it exists, or some default URI otherwise...
    redirect_to(session[:return_to] || default)
    # ...evaluates to session[:return_to] unless it’s nil
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

end
