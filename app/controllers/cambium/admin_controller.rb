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
      if @object.update(update_params)
        redirect_to(
          admin_routes.index,
          :notice => "#{@object.class.to_s} updated!"
        )
      else
        render 'edit'
      end
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

      def update_params
        params
          .require(@object.class.to_s.humanize.downcase.to_sym)
          .permit(admin_form.fields.to_h.keys)
      end

  end
end
