class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_comment = PostComment.new(post_comment_params)
    @post_comment.user_id = current_user.id
    @post_comment.post_id = @post.id
    if @post_comment.save
      flash[:notice] = 'コメントを投稿しました。'
      redirect_to request.referer
    else
      @post_comments = @post.post_comments.order(created_at: :desc)
      @user = @post.user
      flash[:notice] = 'コメントできませんでした'
      redirect_to post_path(@post)
    end
  end

  def destroy
    @post_comment = PostComment.find(params[:id])
    if @post_comment.user == current_user
      @post_comment.destroy
      flash[:notice] = 'コメントを削除しました。'
      redirect_to request.referer
    else
      flash[:notice] = 'コメントの削除に失敗しました。'
      redirect_to request.referer
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
