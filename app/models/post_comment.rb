class PostComment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  # いいね機能をつけるためポリモーフィックを導入
  has_many :favorites, as: :favoritable, dependent: :destroy
  # 通知機能をつけるためポリモーフィックを導入
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :comment, presence: true

  # Favoritesテーブル内にuserが存在（exists?）するかどうかを調べる
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 投稿にコメントされた場合の通知
  after_create :create_notification

  private
    def create_notification
      # コメントされた投稿の所有者に通知を送る
      Notification.create(user_id: post.user.id, notifiable: self)
    end
end
