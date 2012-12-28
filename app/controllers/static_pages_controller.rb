class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @userpost = current_user.userposts.build
                # used in views/shared/_userpost_form.html
      @feed_items = current_user.feed.paginate(page: params[:page])
                # the status feed partial
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
