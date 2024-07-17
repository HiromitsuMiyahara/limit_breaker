class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  # Userモデルにfollowerテーブルはないのでこの書き方でないとエラーになる。
  belongs_to :followed, class_name: "User"
  # 本来、フォローしたユーザーとフォローされたユーザーは同じUserモデルから
  # 持ってきたいが、belongs_to :userとするとどっちがどっちのuserかわからな
  # くなるので、followerとfollowedで分けている。
end
