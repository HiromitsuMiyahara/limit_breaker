class Public::UsersController < ApplicationController
  def mypage
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def show
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to mypage_path, notice: 'プロフィールの編集が完了しました。'
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
  end

  private

  def user_params
    params.require(:user).permit(:name, :body, :weight, :height, :experience, :birth_year, :gender, :profile_image)
  end
end
