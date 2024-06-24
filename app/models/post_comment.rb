class PostComment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  #いいね機能をつけるためポリモーフィックを導入
  has_many :favorites, as: :favoritable, dependent: :destroy

  validates :comment, presence: true

  # Favoritesテーブル内にuserが存在（exists?）するかどうかを調べる
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
