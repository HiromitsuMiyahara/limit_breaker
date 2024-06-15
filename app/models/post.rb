class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :post_image

  validates :body, presence: true

  #画像が設定されない場合はapp/assets/imagesに格納されているno_image.jpgという画像をデフォルト画像で表示する。
  def get_post_image
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    if post_image.variable?
      post_image.variant(resize_to_limit: [100, 100]).processed
    else
      # デフォルト画像を返すか、元の画像をそのまま返す
      post_image
    end
  end
end
