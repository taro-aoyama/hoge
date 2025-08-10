Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users
  root to: redirect('/users/sign_in')

  resources :reservations, only: [:index, :show] do
    member do
      patch :confirm
      patch :decline
    end
  end
end
