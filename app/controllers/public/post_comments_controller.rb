class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :post_commented_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.user_id = current_user.id
    @post_comment.post_id = @post.id
    if @post_comment.save
      @post_comments = @post.post_comments.order(created_at: :desc)
      # redirect_to request.referer
    else
      @post_comments = @post.post_comments.order(created_at: :desc)
      @user = @post.user
      redirect_to post_path(@post)
    end
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    if @post_comment.user == current_user
      @post = @post_comment.post
      @post_comment.destroy
      @post_comments = @post.post_comments.order(created_at: :desc)
      # redirect_to request.referer
    else
      redirect_to request.referer
    end
  end

  private
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
    def post_commented_user
      @post_comment = PostComment.find(params[:id])
      unless @post_comment.user == current_user
        redirect_to posts_path
      end
    end
end
