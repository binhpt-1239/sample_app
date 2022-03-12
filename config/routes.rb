Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "static_pages/home"
    get "static_pages/help"
    get "signup"  => "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :password_resets, except: %i(index show destroy)
    resources :account_activations, only: :edit
    resources :microposts, except: %i(index show new)
    resources :relationships, only: %i(create destroy)
  end
end
