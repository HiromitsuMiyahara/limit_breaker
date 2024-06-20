class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :posted_user, only: [:edit, :update]

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = '投稿が完了しました。'
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = '投稿を編集しました。'
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:notice] = '投稿を削除しました。'
      redirect_to mypage_path
    else
      render :index
    end
  end

  private

  def post_params
    params.require(:post).permit(:post_image, :body)
  end

  def posted_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path
    end
  end
end
