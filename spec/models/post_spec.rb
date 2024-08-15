require "rails_helper"

Rspec.describle Post, "モデルに関するテスト", type: :model do
  describe "モデルのテスト" do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:post)).to be val
    end
  end
end
