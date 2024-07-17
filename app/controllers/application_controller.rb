class ApplicationController < ActionController::Base
  private
    # ゲストユーザーが作成した投稿やコメントを削除する
    def reset_guest_data
      # メールアドレスがUser::GUEST_USER_EMAILであるユーザーを取得
      guest_user = User.find_by(email: User::GUEST_USER_EMAIL)
      # ゲストユーザーが作成した投稿を削除。any?メソッドは、レビューが存在する場合にtrueを返す。
      guest_user.posts.destroy_all if guest_user.posts.any?
      # ゲストユーザーが作成したコメントを削除
      guest_user.post_comments.destroy_all if guest_user.post_comments.any?
      # ゲストユーザーが作成した筋トレ記録を削除
      guest_user.records.destroy_all if guest_user.records.any?
    end
end
