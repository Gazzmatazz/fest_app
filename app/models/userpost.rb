class Userpost < ActiveRecord::Base
  # all attributes in a model are accessible by default,
  # only one attribute needs to be editable through the web, the content attribute, 
  # so we remove :user_id  from the accessible list
  attr_accessible :content

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # posts should be ordered newest first (by default they are ordered by id, i.e. oldest first)
  default_scope order: 'userposts.created_at DESC'
  # Using the Rails facility default_scope with an :order parameter
  # DESC is SQL for “descending”

  # Return posts from the users that the given user is following. 
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
  # this code and SQL subselect would yield this for user 1:
  # SELECT * FROM userposts WHERE
  #                       user_id IN   (SELECT followed_id FROM relationships
  #                                     WHERE follower_id = 1)
  #                       OR user_id = 1

end
