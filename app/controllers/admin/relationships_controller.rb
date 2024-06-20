class Admin::RelationshipsController < ApplicationController
  before_action :authenticate_admin!

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
  
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
end
