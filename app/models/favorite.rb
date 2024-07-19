class Favorite < ApplicationRecord
  belongs_to :user
  # 投稿とコメントどちらもいいねするためポリモーフィックを導入
  belongs_to :favoritable, polymorphic: true
  # 通知機能をつけるためポリモーフィックを導入
  has_one :notification, as: :notifiable, dependent: :destroy

  # 同じ投稿を重複していいねができないようにする
  validates :user_id, uniqueness: { scope: [:favoritable_id, :favoritable_type] }

  # 通知機能
  after_create :create_notification

  private

  def create_notification
    if favoritable_type == 'Post'
      # 投稿にいいねされた場合の通知
      Notification.create(user_id: favoritable.user.id, notifiable: self)
    elsif favoritable_type == 'PostComment'
      # コメントにいいねされた場合の通知
      Notification.create(user_id: favoritable.post.user.id, notifiable: self)
    end
  end
end
