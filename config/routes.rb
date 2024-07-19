Rails.application.routes.draw do
  # 利用者用
  # URL /users/sign_in ...
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # ゲストログインの処理を行うためのルーティング
  devise_scope :user do
    post "guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  root to: "public/homes#top"
  get "/admin", to: "admin/homes#top"

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update] do
      get "favorites", to: "users#favorites", on: :member
      resource :relationships
      get "/followers", to: "relationships#followers"
      get "/followings", to: "relationships#followings"
    end

    resources :posts do
      resources :post_comments, only: [:destroy]
    end

    resources :records, only: [:new, :index, :show, :edit, :update, :destroy]

    get "/search", to: "searches#search"
  end

  scope module: :public do
    get "/about" => "homes#about"
    get "/mypage", to: "users#mypage"
    get "/users/unsubscribe", to: "users#unsubscribe"
    patch "/users/withdraw", to: "users#withdraw"

    get "/search", to: "searches#search"

    resources :notifications, only: [:update]

    resources :posts do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy] do
        resource :favorites, only: [:create, :destroy]
      end
    end

    resources :records

    resources :users, only: [:show, :edit, :update] do
      get "favorites", to: "users#favorites", on: :member
      resource :relationships, only: [:create, :destroy]
      get "/followers", to: "relationships#followers"
      get "/followings", to: "relationships#followings"
      post "/relationships", to: "relationships#create"
      delete "/relationships", to: "relationships#destroy"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
