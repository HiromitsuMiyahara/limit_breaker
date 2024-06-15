require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LimitBreaker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    #日本語対応化
    config.i18n.default_locale = :ja
    
    #ゲストユーザーが作成した投稿やコメントを削除するように設定
    config.after_initialize do
      #GUEST_USER_EMAILであるユーザーを取得
      guest_user = User.find_or_create_by(email: User::GUEST_USER_EMAIL)
      #ゲストユーザーが作成した投稿を削除。any?メソッドは、レビューが存在する場合にtrueを返す。
      guest_user.posts.each { |post| post.destroy } if guest_user.posts.any?
      # ゲストユーザーが作成したコメントを削除
      guest_user.post_comments.each { |comment| comment.destroy } if guest_user.post_comments.any?
      # ゲストユーザーが作成した筋トレ記録を削除
      guest_user.records.each { |record| record.destroy } if guest_user.records.any?
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end

end
