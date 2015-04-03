module Cambium
  class AdminController < ActionController::Base

    before_filter :authenticate_admin!

    layout "admin"

    # include Cambium::CambiumHelper

    private

      def authenticate_admin!
        authenticate_user!
        if user_signed_in? && current_user.is_admin?
          not_found
        end
      end

  end
end
