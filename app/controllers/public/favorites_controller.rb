class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_favoritable
  
  def create
    favorite = @favoritable.favorites.new(user: current_user)
    if favorite.save
      redirect_to request.referer
    else
      redirect_to request.referer, alert: 'いいねに失敗しました。'
    end
  end

  def destroy
    favorite = @favoritable.favorites.find_by(user: current_user)
    if favorite.destroy
      redirect_to request.referer
    else
      redirect_to request.referer, alert: 'いいねの取り消しに失敗しました。'
    end
  end

  private

  def find_favoritable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @favoritable = $1.classify.constantize.find(value)
      end
    end
  end
end
