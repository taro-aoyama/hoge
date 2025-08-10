Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users
  root to: 'reservations#new'

  resources :reservations, only: [:new, :create, :show] do
    post :confirm, on: :collection
  end
end
