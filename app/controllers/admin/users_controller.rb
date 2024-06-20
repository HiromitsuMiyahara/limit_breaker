class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.non_guest.page(params[:page]) #non_guestを付けて、guestuserの表示を除外
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page])
    @records = Record.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
     @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'プロフィールの編集が完了しました。'
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :body, :weight, :height, :experience, :birth_year, :gender, :profile_image, :email, :is_active)
  end
end
