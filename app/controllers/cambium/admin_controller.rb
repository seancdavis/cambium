module Cambium
  class AdminController < ActionController::Base

    before_filter :authenticate_admin!

    layout "admin"

    include CambiumHelper

    def index
      @collection = admin_view.model.constantize.send(admin_view.scope)
    end

    private

      def authenticate_admin!
        authenticate_user!
        not_found unless current_user.is_admin?
      end

  end
end
