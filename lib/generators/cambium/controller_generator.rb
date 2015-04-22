require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  class ControllerGenerator < Rails::Generators::Base

    desc "Installs a controller to use in Cambium's CMS."

    source_root File.expand_path('../../templates', __FILE__)

    argument :model, :type => :string

    # class_option(
    #   :config_check,
    #   :type => :boolean,
    #   :default => true,
    #   :description => "Verify config at config/initializers/cambium.rb"
    # )

    # If there is no configuration file tell the user to run
    # that generator first (unless user has manually
    # overridden).
    #
    # def verify_configuration
    #   if options.config_check?
    #     unless File.exists?("#{Rails.root}/config/initializers/cambium.rb")
    #       help_message('cambium_prereqs')
    #       exit
    #     end
    #   end
    # end

    def confirm_model
      @model = model.constantize
    rescue
      puts "Can't find the model: #{model}"
      exit
    end

    def set_model_attrs
      @model_pl = @model.to_s.humanize.downcase.pluralize
      @columns = @model.columns.reject { |col|
        ['id','created_at','updated_at'].include?(col.name) }
    end

    def generate_controller
      generate "controller admin/#{@model_pl}"
      template(
        "app/controllers/admin/controller.rb.erb",
        "app/controllers/admin/#{@model_pl}_controller.rb",
        :force => true
      )
    end

    def add_routes
      route  = "  namespace :admin do\n"
      route += "    resources :#{@model_pl}\n"
      route += "  end\n"
      insert_into_file(
        "config/routes.rb",
        route,
        :after => /mount\ Cambium\:(.*)\n/
      )
    end

    def add_config_file
      template "config/admin/controller.yml.erb", "config/admin/#{@model_pl}.yml"
    end

    def add_sidebar_item
      config  = "#{@model_pl}:\n"
      config += "  label: #{@model_pl.titleize}\n"
      config += "  route: main_app.admin_#{@model_pl}\n"
      config += "  icon: cog\n"
      config += "  controllers: ['#{@model_pl}']\n"
      append_to_file("config/admin/sidebar.yml", config)
    end

  end
end
