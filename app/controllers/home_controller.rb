class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # This will be the main dashboard after login
  end
end
