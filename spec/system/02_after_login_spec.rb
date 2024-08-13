require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let!(:user) { create(:user,email:Faker::Internet.email,password:'password') }
  let!(:other_user) { create(:user,email:Faker::Internet.email,password:'password') }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'MyPageを押すと、自分のユーザ詳細画面に遷移する' do
        click_link "MyPage"
        is_expected.to eq '/mypage'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        click_link "About"
        is_expected.to eq '/about'
      end
      it 'Postsを押すと、投稿一覧画面に遷移する' do
        click_link "Posts"
        is_expected.to eq '/posts'
      end
      it 'Serachを押すと、検索画面に遷移する' do
        click_link "Search"
        is_expected.to eq '/search'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: mypage_path
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分の投稿と他人の投稿の本文のリンク先がそれぞれ正しい' do
        expect(page).to have_link post.body, href: post_path(post)
        expect(page).to have_link other_post.body, href: post_path(other_post)
      end
    end
  end 
end
