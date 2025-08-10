class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.where(reservable_for_regular: true)
  end
end
