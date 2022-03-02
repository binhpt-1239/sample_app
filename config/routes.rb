Rails.application.routes.draw do
  root "static_pages#home"
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "static_pages/help"
    get "static_pages/log_in"
    get "static_pages/log_up"
  end
end
