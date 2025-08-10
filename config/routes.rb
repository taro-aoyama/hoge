Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users

  # Set the root path to the home controller's index action.
  # The `before_action :authenticate_user!` in HomeController will handle
  # redirecting unauthenticated users to the sign-in page.
  root "home#index"
end
