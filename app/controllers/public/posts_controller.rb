class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :posted_user, only: [:edit, :update]

  def new
    @post = Post.new
  end

  def index
    @post = Post.new
    # 最新の投稿から降順に並べ替えて、フォローしているユーザーと自分の投稿のみ表示。
    @posts = Post.where(user_id: current_user.following_ids + [current_user.id]).order(created_at: :desc).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comments = @post.post_comments.order(created_at: :desc)
    @post_comment = PostComment.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿しました。"
      redirect_to posts_path
    else
      @posts = Post.where(user_id: current_user.following_ids + [current_user.id]).order(created_at: :desc).page(params[:page])
      flash.now[:notice] = "投稿が失敗しました。"
      render :index
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿を編集しました。"
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = "編集が失敗しました。"
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:notice] = "投稿を削除しました。"
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
