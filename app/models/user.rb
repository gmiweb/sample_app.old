class User < ActiveRecord::Base
  # Make sure to force lower case emails.
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # email is not case sensitive and requires it to be unique. However there is an added database
  # validation check for sanity because we can only test at the memory level here.
  # If patron submitted twice during POST it is possible for this to pass when it should fail.
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
end