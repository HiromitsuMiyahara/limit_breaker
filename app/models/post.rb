class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :post_image

  validates :body, presence: true

  #検索機能
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("body LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("body LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("body LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("body LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end

  #画像が設定されない場合はapp/assets/imagesに格納されているno_image.jpgという画像をデフォルト画像で表示する。
  def get_post_image
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      post_image
  end
end
