class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @userpost = current_user.userposts.build
                # used in views/shared/_userpost_form.html
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
                # the views/shared/_feed partial
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
