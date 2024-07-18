class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true

  # 性別をプロフィールに表示させる。
  enum gender: { man: 0, woman: 1 }

  # 検索機能
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end

  # # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # #relationshipsとreverse_of_relationshipsがあるが、わかりにくいため名前をつけているだけ。
  # #class_name: "Relationship"でRelationshipテーブルを参照します。
  # #foreign_key(外部キー)で参照するカラムを指定。

  # # 一覧画面で使う
  # #「has_many :テーブル名, through: :中間テーブル名」 の形を使って、テーブル同士が中間テーブルを
  # #通じてつながっていることを表現します。(followerテーブルとfollowedテーブルのつながりを表す）
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # #フォロー・フォロワーの一覧画面で、user.followersという記述でフォロワーを表示したいので、
  # #throughでスルーするテーブル、sourceで参照するカラムを指定。

  # # フォローしたときの処理
  def follow(user)
    relationships.create(followed_id: user.id)
  end
  # # フォローを外すときの処理
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
  # #フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # スコープで,検索した後退会済みユーザーを表示させないように有効の会員のみ含めるよう定義
  scope :is_active, -> { where(is_active: true) }
  # ゲストユーザーは表示させないようにする。
  scope :non_guest, -> { where.not(email: "guest@example.com") }
  # is_activeとnon_guestの上記二つを組み合わせる。
  scope :active_non_guest, -> { is_active.non_guest }

  # プロフィール画像設定
  has_one_attached :profile_image
  # 画像がなければno_imeageが適用されるよう設定
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # ログイン時に退会済みのユーザーが同じアカウントでログイン出来ないようにする。
  def active_for_authentication?
    super && (is_active == true)
  end

  # sessions_controller.rbで記述したUser.guestのguestメソッドを定義
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user| # データの検索と作成を自動的に判断して処理を行う
      user.password = SecureRandom.urlsafe_base64 # ランダムな文字列を生成するRubyのメソッドの一種
      user.name = "guestuser"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end
end
