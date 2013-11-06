class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  # Make sure to force lower case emails.
  has_secure_password
  before_save { email.downcase! }
  before_create :create_remember_token
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # email is not case sensitive and requires it to be unique. However there is an added database
  # validation check for sanity because we can only test at the memory level here.
  # If patron submitted twice during POST it is possible for this to pass when it should fail.
  validates :email, presence: true,
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6}

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # Could just return the microposts variable here, but this code generalizes
    # much more naturally to the full status feed needed in Chapter 11
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end