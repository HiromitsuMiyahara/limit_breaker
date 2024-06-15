# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private
  #退会したアカウントでログインさせないようにする
  def user_state
    user = User.find_by(email: params[:user][:email])
    if user
      if user.valid_password?(params[:user][:password]) && (user.is_active == false)
        flash[:notice] = "退会済みです。再度ご登録をしてご利用ください"
        redirect_to new_user_registration_path
      else
        flash[:notice] = "項目を入力してください"
      end
    else
      flash[:notice] = "該当するユーザーが見つかりません"
    end
  end
end
