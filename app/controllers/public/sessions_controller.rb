# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  # サインインしたらマイページへ遷移
  def after_sign_in_path_for(resource)
    mypage_path
  end

  # サインアウトしたらサインイン画面に遷移
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  #ゲストでサインイン
  def guest_sign_in
    user = User.guest

      guest_user = user
      #ゲストユーザーが作成した投稿を削除。any?メソッドは、レビューが存在する場合にtrueを返す。
      guest_user.posts.each { |post| post.destroy } if guest_user.posts.any?
      # ゲストユーザーが作成したコメントを削除
      guest_user.post_comments.each { |comment| comment.destroy } if guest_user.post_comments.any?
      # ゲストユーザーが作成した筋トレ記録を削除
      guest_user.records.each { |record| record.destroy } if guest_user.records.any?


    sign_in user
    flash[:notice] = "ゲストユーザーでログインしました。"
    redirect_to mypage_path
  end

  # ゲストがサインアウトしたら投稿全てを削除
  def destroy
    reset_guest_data if current_user.email == User::GUEST_USER_EMAIL
    super
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
  # 退会したアカウントでログインさせないようにする
  def user_state
  user = User.find_by(email: params[:user][:email])

    if user
      if user.valid_password?(params[:user][:password])
        if user.is_active == false
          flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
          redirect_to new_user_registration_path
        end
      else
        flash.now[:notice] = "メールアドレスまたはパスワードが正しくありません。"
      end
    else
      flash.now[:notice] = "メールアドレスまたはパスワードが正しくありません。"
    end
  end
end
