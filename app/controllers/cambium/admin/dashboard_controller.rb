class Cambium::Admin::DashboardController < Cambium::AdminController

  def index
    redirect_to admin_dashboard_path
  end

  def show
  end

end
