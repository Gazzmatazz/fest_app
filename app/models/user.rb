# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)

# To update Schema info type command:   bundle exec annotate

class User < ActiveRecord::Base

  # attr_accessible() and validates() are methods, we can omit the ()
  
  # Attributes that can be modified by outside users: 	
  attr_accessible :name,  :email,  :password,  :password_confirmation
  
  # Rails method that checks presence of passwords and that they match
  has_secure_password
  
  # posts should be destroyed when their associated user is destroyed
  has_many :userposts,   dependent: :destroy
  has_one :profile,   dependent: :destroy

  # Note: as the userposts table has a user_id attribute to identify the user,
  # Rails infers this as a foreign key. Rails expects a foreign key of the form
  # <class>_id, where <class> is the lower-case version of the class name (user)

  # For the relationships table we must specify the foreign key here as 
  # we used the attribute name "follower_id" instead of "user_id"
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # Destroying a user should also destroy that user’s relationships

  has_many :followed_users, through: :relationships, source: :followed
  # the :source parameter tells Rails that the source of the followed_users array 
  # is the set of followed_id. Otherwise rails would look for followed_users_id

  # unlike the relationship asociation, which uses follower_id as foreign key
  # the reverse_relationships uses followed_id
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  # As we named it reverse_relationships we have to specify the class is "Relationship"

  has_many :followers, through: :reverse_relationships, source: :follower
  # we could leave out the source here as Rails would look for follower_id

  # to ensure email uniqueness, set email address to lower-case before saving to the database. 
  before_save { |user| user.email = email.downcase }

  #  run method create_remember_token before saving the user (create or update actions) 
  before_save :create_remember_token
  
  # Rails validates presence of attribute using the blank? method
  validates :name,  	presence: true,    length: { maximum: 40 }
  
  # validation uses a regular expression (REGEX) to define the format, 
  # along with the :format argument to the validates method
  # VALID_EMAIL_REGEX is a Ruby constant
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,   presence: true,    
  						        format: { with: VALID_EMAIL_REGEX },
  						        uniqueness: { case_sensitive: false }
  						        # Rails infers uniqueness to be true here

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true


  def feed
    # initial implementation for a status feed of main user only was
    # Userpost.where("user_id = ?", id)
    # the '?' ensures id is 'escaped' before inclusion in the SQL query (security)
    # Best practice escaping variables injected into SQL statements

    Userpost.from_users_followed_by(self)
    # defined in models/userpost.rb
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  # create a follow relationship
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  # destroy a follow relationship
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end


  # private methods used internally by the User model only
  private

    # As this method needs to assign to one of the user attributes, it uses 'self'
    # Without 'self' the assignment would create a local variable remember_token
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
