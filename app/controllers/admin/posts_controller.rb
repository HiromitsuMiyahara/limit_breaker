class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.all.order(created_at: :desc) 
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      flash[:notice] = '投稿を編集しました。'
      redirect_to admin_post_path(post.id)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:notice] = '投稿を削除しました。'
      redirect_to admin_posts_path
    else
      flash.now[:notice] = '削除に失敗しました。'
      render :show
    end
  end

  def post_params
    params.require(:post).permit(:post_image, :body)
  end
end
