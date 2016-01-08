class Cambium::Admin::SettingsController < Cambium::AdminController

  before_filter :not_found, :except => [:index, :update]

  def index
    exp_settings = admin_view.form.edit.fields.to_h.stringify_keys.keys
    (exp_settings - Cambium::Setting.keys).each do |key|
      Cambium::Setting.create(:key => key)
    end
    @collection = admin_model.alpha
    respond_to do |format|
      format.html
      format.csv { send_data admin.to_csv(@collection) }
    end
  end

  private

    def create_params
      obj = admin_model.to_s.gsub(/Cambium::/, '').tableize.singularize.to_sym
      p = params.require(obj).permit(:value)
    end

end
