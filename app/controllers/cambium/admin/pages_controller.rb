class Cambium::Admin::PagesController < Cambium::AdminController

  private

    def create_params
      p = params
        .require(admin_model.to_s.tableize.singularize.to_sym)
        .permit(admin_form.fields.to_h.keys)
      if params[:page][:template_data].present?
        data = @object.template_data.merge(params[:page][:template_data])
        p = p.merge(:template_data => data)
      end
      p
    end
end
