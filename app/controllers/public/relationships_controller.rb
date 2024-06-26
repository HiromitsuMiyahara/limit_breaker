class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page])
  end

  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.page(params[:page])
  end

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    flash[:notice] = 'フォローしました。'
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    flash[:notice] = 'フォローを解除しました。'
    redirect_to  request.referer
  end
end
