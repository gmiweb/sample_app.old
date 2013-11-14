class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  #scope :including_replies, lambda  { |user_id| where(:in_reply_to => user_id) }

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    #followed_user_ids = user.followed_user_ids
    #where("user_id IN (?) OR user_id = ?", followed_user_ids, user)

    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_reply_to = :user_id",
          user_id: user)
  end
end