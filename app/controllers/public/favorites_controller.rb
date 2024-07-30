class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_favoritable

  def create
    @favorite = @favoritable.favorites.new(user: current_user)
    @favorite.save
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
      params.each do |name, value|
        # name が「xxx_id」の形式であるかをチェック
        if name =~ /(.+)_id$/
          @favoritable = $1.classify.constantize.find(value)
        end
        # /(.+)_id$/ は、文字列の末尾が「_id」で終わるものを探している
        # $1 には、「_id」の前の部分が入る（例えば、「post」や「post_comment」）。
        # $1.classify は、この部分をクラス名（大文字始まり）に変換（例えば、「Post」や「PostComment」）。
        # .constantize は、文字列を実際のクラスに変換
        # .find(value) は、そのクラスの中で特定のIDを持つレコードを探す。
      end
    end
end
