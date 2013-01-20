class Search < ActiveRecord::Base
  attr_accessible :city, :gender, :music

  def users
  	# Get the users who match the Search result,
  	# place result in this instant variable so we don't have one user occuring multiple time in search result,
  	# find_users defined in private functions below, it returns 'users' 
    @users ||= find_users
  end
  
private
  def find_users
  	# Get ALL users and order them by name
    users = User.order(:name)
   
    # filter that users list with where clauses that test for each parameter passed in search
    users = users.joins(:profile).where("music like ?", "%#{music}%") if music.present?   
    users = users.joins(:profile).where("gender like ?", "#{gender}") if gender.present?
    users = users.joins(:profile).where("city like ?", "%#{city}%") if city.present?

    # return users matched to the users method above which in turn displays result in show.html
    users
  end

end