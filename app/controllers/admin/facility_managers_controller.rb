module Admin
  class FacilityManagersController < ApplicationController
    before_action :set_facility_manager, only: [:show, :edit, :update]

    def index
      @facility_managers = User.where(role: :facility_manager)
    end

    def show
    end

    def edit
      @facilities = Facility.all
    end

    def update
      if @facility_manager.update(facility_manager_params)
        redirect_to admin_facility_manager_path(@facility_manager), notice: 'Facility assignments were successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_facility_manager
      @facility_manager = User.find(params[:id])
    end

    def facility_manager_params
      params.require(:user).permit(facility_ids: [])
    end
  end
end
