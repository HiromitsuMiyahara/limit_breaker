class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  
  # # フォローをした、されたの関係
  # has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # #relationshipsとreverse_of_relationshipsがあるが、わかりにくいため名前をつけているだけ。
  # #class_name: "Relationship"でRelationshipテーブルを参照します。
  # #foreign_key(外部キー)で参照するカラムを指定。
  
  # # 一覧画面で使う
  # #「has_many :テーブル名, through: :中間テーブル名」 の形を使って、テーブル同士が中間テーブルを
  # #通じてつながっていることを表現します。(followerテーブルとfollowedテーブルのつながりを表す）
  # has_many :followings, through: :relationships, source: :followed
  # has_many :followers, through: :reverse_of_relationships, source: :follower
  # #フォロー・フォロワーの一覧画面で、user.followersという記述でフォロワーを表示したいので、
  # #throughでスルーするテーブル、sourceで参照するカラムを指定。
  
  # # フォローしたときの処理
  # def follow(user_id)
  #   relationships.create(followed_id: user_id)
  # end
  # # フォローを外すときの処理
  # def unfollow(user_id)
  #   relationships.find_by(followed_id: user_id).destroy
  # end
  # #フォローしているか判定
  # def following?(user)
  #   followings.include?(user)
  # end
  
  has_one_attached :profile_image
end
