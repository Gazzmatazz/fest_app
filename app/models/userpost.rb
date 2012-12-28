class Userpost < ActiveRecord::Base
  # all attributes in a model are accessible by default,
  # only one attribute needs to be editable through the web, the content attribute, 
  # so we remove :user_id  from the accessible list
  attr_accessible :content

  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # posts should be ordered newest first (by default they are ordered by id, i.e. oldest first)
  default_scope order: 'userposts.created_at DESC'
  # Using the Rails facility default_scope with an :order parameter
  # DESC is SQL for “descending”
end
