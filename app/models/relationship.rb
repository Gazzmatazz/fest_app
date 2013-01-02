# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, class_name: "User"
  # therefore follower_id is a foreign key for association to the user table.
  # Rails would have inferred it to be the foreign key had we named it user_id
  # and not specified class type i.e. class name (user) followed by '_id'

  belongs_to :followed, class_name: "User"
  # The users whose public posts are being followed
  # Also a foreign key as above

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  
end

