Rails.application.routes.draw do
  namespace :public do
    get 'events/index'
  end
  namespace :admin do
    get 'records/index'
    get 'records/show'
    get 'records/update'
    get 'records/destroy'
  end
  namespace :admin do
    get 'searches/search'
  end
  namespace :admin do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  namespace :admin do
    get 'post_comments/destroy'
  end
  # 利用者用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  #ゲストログインの処理を行うためのルーティング
  devise_scope :user do
    post "guest_sign_in", to: "public/sessions#guest_sign_in"
  end


  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  root :to =>"public/homes#top"
  get '/admin', to: 'admin/homes#top'

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update] do
      resource :relationships
        get '/followers', to: 'relationships#followers'
        get '/followings', to: 'relationships#followings'
    end

    resources :posts do
      resources :post_comments, only: [:destroy]
    end

    resources :records, only: [:index, :show, :edit, :update, :destroy]

    get '/search', to: 'searches#search'

  end

  scope module: :public do
    get "/about" => "homes#about"
    get '/mypage', to: 'users#mypage'
    get '/users/unsubscribe', to: 'users#unsubscribe'
    patch '/users/withdraw', to: 'users#withdraw'

    get '/events', to: 'events#index'

    get '/search', to: 'searches#search'

    resources :posts do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy] do
        resource :favorites, only: [:create, :destroy]
      end
    end

    resources :records

    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
        get '/followers', to: 'relationships#followers'
        get '/followings', to: 'relationships#followings'
        post '/relationships', to: 'relationships#create'
        delete '/relationships', to: 'relationships#destroy'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
