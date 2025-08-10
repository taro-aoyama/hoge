class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # Deviseのログイン後のリダイレクト先をカスタマイズ
  def after_sign_in_path_for(resource)
    # resourceはcurrent_userに相当
    user_dashboard_path
  end
end
