class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @post_comment = PostComment.find(params[:id])
    if @post_comment.destroy
      flash[:notice] = "コメントを削除しました。"
      redirect_to request.referer
    else
      flash[:notice] = "コメントの削除に失敗しました。"
      redirect_to request.referer
    end
  end
end
