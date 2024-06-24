class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
   #いいね機能をつけるためポリモーフィックを導入
  has_many :favorites, as: :favoritable, dependent: :destroy
  
  has_one_attached :post_image

  validates :body, presence: true

  #Favoritesテーブル内にuserが存在（exists?）するかどうかを調べる
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #検索機能
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("body LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("body LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("body LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("body LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end
end
