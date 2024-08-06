require "rails_helper"

describe "[STEP1] ユーザログイン前のテスト" do
  describe "トップ画面のテスト" do
    before do
      visit root_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/"
      end
      it "Log inリンクが表示される" do
        log_in_link = find_all('a')[6].text
        expect(log_in_link).to match(/Log in/)
      end
      it "Log inリンクの内容が正しい" do
        log_in_link = find_all('a')[6].text
        expect(page).to have_link log_in_link, href: new_user_session_path
        # expect(page).to have_link "Log in", href: new_user_session_pathでもOK
      end
      it "Sign upリンクが表示される: 緑色のボタンの表示が「Sign up」である" do
        sign_up_link = find_all('a')[7].text
        expect(sign_up_link).to match(/Sign up/)
      end
      it "Sign upリンクの内容が正しい" do
        sign_up_link = find_all('a')[7].text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
        # expect(page).to have_link "Sign up", href: new_user_session_pathでもOK
      end
    end
  end

  describe "アバウト画面のテスト" do
    before do
      visit about_path
    end

    context "表示内容の確認" do
      it "URLが正しい" do
        expect(current_path).to eq "/about"
      end
    end
  end

  describe "ヘッダーのテスト: ログインしていない場合" do
    before do
      visit root_path
    end

    context "表示内容の確認" do
      it "aboutリンクが表示される: 左上から1番目のリンクが「About」である" do
        about_link = find_all('a')[1].text
        expect(about_link).to match(/About/)
      end
      it "Signupリンクが表示される: 左上から2番目のリンクが「Signup」である" do
        signup_link = find_all('a')[2].text
        expect(signup_link).to match(/Signup/)
      end
      it "Log inリンクが表示される: 左上から3番目のリンクが「Log in」である" do
        login_link = find_all('a')[3].text
        expect(login_link).to match(/Login/)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it "Aboutを押すと、アバウト画面に遷移する" do
        # about_link = find_all('a')[1].text
        # about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '') #不要な改行や前後の空白を削除するための記述
        # click_link about_link
        click_link "アバウト"
        expect(current_path).to eq ("/about")
      end
      it "Sign upを押すと、新規登録画面に遷移する" do
        # signup_link = find_all('a')[2].text
        # signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        # click_link signup_link, match: :first # match: :firstは最初に一致するリンクをクリックする
        click_link "新規登録"
        expect(current_path).to eq ("/users/sign_up")
      end
      it "Log inを押すと、ログイン画面に遷移する" do
        # login_link = find_all('a')[3].text
        # login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        # click_link login_link, match: :first
        click_link "Login"
        expect(current_path).to eq ("/users/sign_in")
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'Sign up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'Sign up'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button 'Sign up' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button 'Sign up'
        expect(current_path).to eq '/mypage'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user,email:Faker::Internet.email,password:'password') }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「Log in」と表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
      it 'nameフォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/mypage'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user,email:Faker::Internet.email,password:'password') }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end

    context 'ヘッダーの表示を確認' do
      it 'アバウトリンクが表示される: 左上から1番目のリンクが「About」である' do
        about_link = find_all('a')[1].text
        expect(about_link).to match(/About/)
      end
      it 'Noticeが表示される: 左上から2番目が「Notice」である' do
        expect(page).to have_content 'Notice'
      end
      it 'Postsリンクが表示される: 左上から3番目のリンクが「Posts」である' do
        posts_link = find_all('a')[2].text
        expect(posts_link).to match(/Posts/)
      end
      it 'MyPageリンクが表示される: 左上から4番目のリンクが「MyPage」である' do
        mypage_link = find_all('a')[3].text
        expect(mypage_link).to match(/MyPage/)
      end
      it 'Searchリンクが表示される: 左上から5番目のリンクが「Search」である' do
        search_link = find_all('a')[4].text
        expect(search_link).to match(/Search/)
      end
      it 'Trainingリンクが表示される: 左上から5番目のリンクが「Training」である' do
        training_link = find_all('a')[5].text
        expect(training_link).to match(/Training/)
      end
      it 'LogOutリンクが表示される: 左上から5番目のリンクが「LogOut」である' do
        logout_link = find_all('a')[6].text
        expect(logout_link).to match(/Logout/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user,email:Faker::Internet.email,password:'password') }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
      click_link 'Logout'
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、Login画面になっている' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end
