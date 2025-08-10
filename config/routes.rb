Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users

  # ダッシュボードへのルーティング
  get 'dashboard', to: 'dashboards#show', as: :user_dashboard
  namespace :dashboards do
    get :general_user
    get :facility_manager
    get :system_admin
  end

  # ログイン後のリダイレクト先をダッシュボードに設定
  root to: 'dashboards#show'
end
