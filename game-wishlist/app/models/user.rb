class User < ActiveRecord::Base
  has_many :games
  has_secure_password
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password_digest, presence: true

  def recent(arr = [])
    limit = 5

    if arr.count > limit
      last = arr.count - limit
    else
      last = 0
    end

    arr[last..-1].reverse
  end
  
  def self.logged_in?(session)
    !!session["user_id"]
  end

  def self.current_user(session)
    User.find_by(id: session["user_id"])
  end
end