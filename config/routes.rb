Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users

  root 'facilities#index'

  resources :facilities, only: [:index] do
    resources :reservations, only: [:new, :create, :show]
  end
end
