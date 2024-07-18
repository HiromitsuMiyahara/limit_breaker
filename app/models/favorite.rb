class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true
  # 通知機能をつけるためポリモーフィックを導入
  has_one :notification, as: :notifiable, dependent: :destroy

  # 同じ投稿を重複していいねができないようにする
  validates :user_id, uniqueness: { scope: [:favoritable_id, :favoritable_type] }
  # validates :user_id, uniqueness: {scope: :post_comment_id}
end
