module Public::NotificationsHelper
  # 通知を表示する
  def notification_message(notification)
    case notification.notifiable_type
    when "Favorite"
      favoritable = notification.notifiable.favoritable
      if favoritable.is_a?(Post)
        "投稿した#{favoritable.body}が#{notification.notifiable.user.name}さんにいいねされました"
      elsif favoritable.is_a?(PostComment)
        "コメントした#{favoritable.comment}が#{notification.notifiable.user.name}さんにいいねされました"
      else
        "いいねされました"
      end
    when "PostComment"
      post = notification.notifiable.post
      "#{notification.notifiable.user.name}さんが#{post.body}にコメントしました"
    else
      "通知の種類が不明です"
    end
  end
end
