# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# to update run command: bundle exec annotate

class User < ActiveRecord::Base

  # attr_accessible() and validates() are methods, we can omit the ()
  
  # Attributes that can be modified by outside users: 	
  attr_accessible :name, :email, :password, :password_confirmation
  
  # Rails method that checks presence of passwords and that they match
  has_secure_password
  
  # posts should be destroyed when their associated user is destroyed
  has_many :userposts, dependent: :destroy

  # to ensure email uniqueness, set email address to lower-case before saving to the database. 
  before_save { |user| user.email = email.downcase }
  #  run method create_remember_token before saving the user
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
    # preliminary implementation for the userpost status feed
    Userpost.where("user_id = ?", id)
    # the '?' ensures id is 'escaped' before inclusion in the SQL query (security)
    # Best practice escaping variables injected into SQL statements
  end

  # private methods used internally by the User model only
  private

    # As this method needs to assign to one of the user attributes, it uses 'self'
    # Without 'self' the assignment would create a local variable remember_token
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
