class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end
  
  def edit
    @post = Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:notice] = '投稿を削除しました。'
      redirect_to request.referer
    else
      flash.now[:notice] = '削除に失敗しました。'
      render :show
    end
  end
end
