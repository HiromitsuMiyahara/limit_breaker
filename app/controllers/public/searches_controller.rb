class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "User"
      @users = User.active_non_guest.looks(params[:search], params[:word]).page(params[:page]).order(created_at: :desc) # active_non_guestはUserモデルで定義。退会済みとのゲストユーザーは除外。
    else
      @posts = Post.looks(params[:search], params[:word]).page(params[:page]).order(created_at: :desc)
    end
  end
end
