class Cambium::Admin::SettingsController < Cambium::AdminController

  before_filter :not_found, :except => [:index, :update]

  def index
    expected_keys = admin_view.form.edit.fields.to_h.stringify_keys.keys
    current_keys = Cambium::Setting.keys
    # Add anything that's missing
    (expected_keys - current_keys).each do |key|
      Cambium::Setting.create(:key => key)
    end
    @collection = admin_model.alpha
    # Remove anything extra
    extra_keys = @collection.collect(&:key) - expected_keys
    if extra_keys.size > 0
      Cambium::Setting.where(:key => extra_keys).destroy_all
      @collection = admin_model.alpha
    end
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
