module Cambium
  class AdminController < ActionController::Base

    before_filter :authenticate_admin!

    layout "admin"

    include CambiumHelper

    def index
      @collection = m.send(admin_table.scope)
    end

    def edit
      set_object
    end

    def update
      set_object
    end

    private

      def set_object
        if @object.respond_to?(:slug) && params[:slug]
          @object = m.find_by_slug(params[:slug])
        else
          @object = m.find_by_id(params[:id])
        end
        @obj = @object
      end

      def m
        admin_view.model.constantize
      end

      def authenticate_admin!
        authenticate_user!
        not_found unless current_user.is_admin?
      end

  end
end
