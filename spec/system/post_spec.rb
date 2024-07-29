require "rails_helper"

describe "投稿のテスト" do
  let!(:post) { create(:post,body:"body") }
  describe "マイページ(mypage_path)のテスト" do
    before "マイページ画面への遷移" do
      visit mypage_path
    end
    context "表示の確認" do
      it "URLが'/mypage'であるか" do
        expect(current_path).to eq('/mypage')
      end
      # it "マイページ画面(mypage_path)にアバウトページへのリンクが表示されているか" do
      #   expect(page).to have_link "アバウト", href: about_path
      # end
      it "マイページ画面(mypage_path)に投稿一覧ページへのリンクが表示されているか" do
        expect(page).to have_link "投稿一覧", href: posts_path
      end
      # it "マイページ画面(mypage_path)に検索ページへのリンクが表示されているか" do
      #   expect(page).to have_link "検索", href: search_path
      # end
      # it "マイページ画面(mypage_path)に筋トレ記録ページへのリンクが表示されているか" do
      #   expect(page).to have_link "筋トレ", href: records_path
      # end
      # it "マイページ画面(mypage_path)にログアウトのリンクが表示されているか" do
      #   expect(page).to have_link "ログアウト", href: destroy_user_session_path
      # end
    end
  end
end

describe "投稿一覧画面(posts_path)のテスト" do
  before do
    visit posts_path
  end
  context "一覧表示の確認" do
    it "posts_pathが'/posts'であるか" do
      expect(current_path).to eq("/posts")
    end
    it "一覧表示と投稿フォームが同一画面内に表示されているか" do
      expect(page).to have_field "post[body]"
      expect(page).to have_content post.body
      expect(page).to have_link post.body
    end
    it "投稿ボタンが表示されているか" do
      expect(page).to have_button "投稿"
    end
  end
  context "投稿処理テスト" do
    it "投稿後のリダイレクト先は正しいか" do
      fill_in "post[body]", with: Faker::Lorem.characters(number:10)
      click_button "投稿"
      expect(page).to have_current_path posts_path
    end
  end
end

describe "詳細画面のテスト" do
  before "投稿詳細へ遷移" do
    visit post_path(post)
  end
  context "表示の確認" do
    it "削除リンクが存在しているか" do
      expect(page).to have_link "削除"
    end
    it "編集リンクが存在しているか" do
      expect(page).to have_link "編集"
    end
  end
  context "リンクの遷移先の確認" do
    it "編集の遷移先は編集画面か" do
      edit_link = find_all("a")[1]
      edit_link.click
      expect(current_path).to eq("/posts/" + post.id.to_s + "/edit" )
    end
  end
  context "post削除のテスト" do
    it "post削除のテスト" do
      expect{ list.destroy }.to chage{ Post.count }.by(-1)
    end
  end
end

describe "編集画面のテスト" do
  before do
    visit edit_post_path(post)
  end
  context "表示の確認" do
    it "編集前のタイトルと本文がフォームに表示(セット)されている" do
      expect(page).to have_field "post[body]", with: post.body
    end
    it "保存ボタンが表示されている" do
      expect(page).to have_button "変更を保存"
    end
  end
  context "更新処理に関するテスト" do
    it "更新後のリダイレクト先は正しいか" do
      fill_in "post[body]", with: Faker::Lorem.characters(number:30)
      click_button "変更を保存"
      expect(page).to have_current_path post_path(post)
    end
  end
end