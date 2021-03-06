class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:omniauthable,omniauth_providers:[:facebook]

 def self.from_omniauth(auth)
   find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
     user.provider = auth["provider"]
     user.uid = auth["uid"]
     user.name = auth["info"]["nickname"]
   end
 end

 def self.new_with_session(params, session)
   if session["devise.user_attributes"]
     new(session["devise.user_attributes"]) do |user|
       user.attributes = params
     end
   else
     super
   end
 end

 # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                OR user_id = :user_id", user_id: id)
  end

 # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
end
