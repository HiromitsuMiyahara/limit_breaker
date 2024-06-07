Rails.application.routes.draw do
  # 利用者用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  root :to =>"public/homes#top"
  get '/admin', to: 'admin/homes#top'

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :destroy]
  end

  scope module: :public do
    get "/about" => "homes#about"
    get '/mypage', to: 'users#mypage'
    get '/users/unsubscribe', to: 'users#unsubscribe'
    patch '/users/withdraw', to: 'users#withdraw'

    get '/search', to: 'public/searches#search'

    get '/users/:user_id/followers', to: 'relationships#followers'
    get '/users/:user_id/followings', to: 'relationships#followings'
    post '/users/:user_id/relationships', to: 'relationships#create'
    delete '/users/:user_id/relationships', to: 'relationships#destroy'

    resources :posts do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy] do
        resource :favorites, only: [:create, :destroy]
      end
  end

    resources :records

    resources :users, only: [:show, :edit, :update]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
