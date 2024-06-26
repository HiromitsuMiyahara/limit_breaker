class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.active_non_guest.looks(params[:search], params[:word]).page(params[:page])#active_non_guestはUserモデルで定義。退会済みとのゲストユーザーは除外。
    else
      @posts = Post.looks(params[:search], params[:word]).page(params[:page])
    end
  end
end
