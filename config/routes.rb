Rails.application.routes.draw do
  devise_for :users
  root "home#index"

  resources :products, only: %i[index show], path: "catalog", as: :catalog, param: :slug
  resource :shipping_ledger, only: :show
  resources :cart_items, only: %i[create update destroy]
  resources :orders, only: :create
  resources :newsletter_subscriptions, only: :create

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*.
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
