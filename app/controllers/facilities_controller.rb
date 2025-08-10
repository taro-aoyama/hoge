class FacilitiesController < ApplicationController
  def index
    @q = Facility.active.ransack(params[:q])
    @facilities = @q.result(distinct: true).page(params[:page])
  end

  def show
    @facility = Facility.find(params[:id])
  end
end
