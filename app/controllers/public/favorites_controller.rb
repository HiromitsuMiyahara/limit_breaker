class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_favoritable

  def create
    @favorite = @favoritable.favorites.new(user: current_user)
    @favorite.save
    # app/views/favorites/create.js.erbを参照する
    # app/views/favorites/create.js.erbを参照する
  end

  def destroy
    @favorite = @favoritable.favorites.find_by(user: current_user)
    @favorite.destroy
    # app/views/favorites/destroy.js.erbを参照する
  end

  private
  # ポリモーフィック関連の対象を見つける
  # 適切なモデルのインスタンスを取得、取得したインスタンスは @favoritable というインスタンス変数に格納
    def find_favoritable
      if params[:post_comment_id]
        @favoritable = PostComment.find(params[:post_comment_id])
      elsif params[:post_id]
        @favoritable = Post.find(params[:post_id])
      end
    end
end
