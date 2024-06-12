class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]

  def mypage
    @user = current_user
    @posts = current_user.posts
    @records = Record.where(user_id: current_user.id)
  end

  def edit
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = 'プロフィールの編集が完了しました。'
      redirect_to mypage_path
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @user = User.find(current_user.id)
    # is_activeカラムをfalseに変更することにより削除フラグを立てる
    @user.update(is_active: false)
    #セッション情報を全て削除
    reset_session
    flash[:notice] = "退会が完了しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :body, :weight, :height, :experience, :birth_year, :gender, :profile_image, :email)
  end

#ユーザーの編集画面へのURLを直接入力された場合にはメッセージを表示してユーザー詳細画面へリダイレクトする。
  def ensure_guest_user
    @user = current_user
    if @user.guest_user? #.guest_user?=モデルで定義したメソッド
      flash[:notice] = "ゲストユーザーはプロフィール編集画面へ遷移できません。"
      redirect_to mypage_path
    end
  end
end
