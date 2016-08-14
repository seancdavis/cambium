class Cambium::Admin::PagesController < Cambium::AdminController

  private

    def create_params
      obj = admin_model.to_s.gsub(/Cambium::/, '').tableize.singularize.to_sym
      p = params.require(obj).permit(admin_form.fields.to_h.keys)
      if params[:page][:template_data].present?
        data = @object.template_data.merge(params[:page][:template_data])
        p = p.merge(:template_data => data)
      end
      p
    end

end
