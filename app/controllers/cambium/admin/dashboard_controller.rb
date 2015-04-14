module Cambium
  class Admin::DashboardController < AdminController

    def index
      redirect_to admin_dashboard_path
    end

    def show
      @versions = PaperTrail::Version.order(:created_at => :desc)
    end

  end
end
