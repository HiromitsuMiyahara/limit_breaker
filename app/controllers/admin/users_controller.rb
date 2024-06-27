class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.non_guest.page(params[:page]).order(created_at: :desc).page(params[:page]) #non_guestを付けて、guestuserの表示を除外
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).order(created_at: :desc).page(params[:page])
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
      flash.now[:notice] = 'プロフィールの編集が失敗しました。'
      render :edit
    end
  end

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id, favoritable_type: "Post").pluck(:favoritable_id)
    @favorite_posts = Post.where(id: favorites).page(params[:page])
    @post = @user.posts
  end

  private

  def user_params
    params.require(:user).permit(:name, :body, :weight, :height, :experience, :birth_year, :gender, :profile_image, :email, :is_active)
  end
end
