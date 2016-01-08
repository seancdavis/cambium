class Cambium::Admin::DocumentsController < Cambium::AdminController

  private

    def create_params
      obj = admin_model.to_s.gsub(/Cambium::/, '').tableize.singularize.to_sym
      p = params.require(obj).permit(admin_form.fields.to_h.keys)
    end

end
