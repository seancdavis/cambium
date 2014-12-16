require 'rake'
require 'rails/generators'
require File.expand_path('../helpers/_autoloader.rb', __FILE__)

class CambiumGenerator < Rails::Generators::Base

  desc "Add all the pieces to your application per your configuration."

  source_root File.expand_path('../templates', __FILE__)

  class_option(
    :config_check, 
    :type => :boolean, 
    :default => true, 
    :description => "Verify config at config/initializers/cambium.rb"
  )

  # If there is no configuration file tell the user to run 
  # that generator first (unless user has manually overridden).
  # 
  def verify_configuration
    if options.config_check?
      unless File.exists?("#{Rails.root}/config/initializers/cambium.rb")
        help_message('cambium_prereqs')
        exit
      end
    end
  end

  # Wrap our config values up in an easier-to-type variable
  # 
  def set_config
    @config = Cambium.configuration
  end

  # Set root url for mailer in development and production
  # 
  def set_url_config
    environment(
      "config.action_mailer.default_url_options = { :host => '#{@config.development_url}' }", 
      :env => "development"
    )
    environment(
      "config.action_mailer.default_url_options = { :host => '#{@config.production_url}' }", 
      :env => "production"
    )
  end

  # Add modernizr to our list of assets to precompile when 
  # we're ready to deploy
  # 
  def set_precompiled_assets
    environment(
      "config.assets.precompile += %w( modernizr.js )",
      :env => "production"
    )
  end

  # Add settings to application config file (config/application.rb)
  # 
  def add_application_config
    environment { file_contents("config/application.rb") }
  end

  # Assets initializer for Rails 4.1+
  # 
  def add_assets_initializer
    file = "config/initializers/assets.rb"
    template(file, file)
  end

  # Add custom gitignore file
  # 
  def add_gitignore
    copy_file("gitignore", ".gitignore")
  end

  # Add a default public controller, so we have a working 
  # home page when we're done.
  # 
  def add_home_controller
    generate "controller home index"
  end

  # Add our default routes file, which is commented out 
  # except for the root path to the home controller.
  # 
  # We don't override routes here in case the user started to 
  # edit their routes file before running this generator.
  # 
  def add_default_routes
    insert_into_file(
      "config/routes.rb",
      file_contents("config/app_routes.rb"),
      :after => "Rails.application.routes.draw do"
    )
  end

  # Add our default public views
  # 
  def add_public_views
    directory "app/views/application"
    directory "app/views/home", :force => true
  end

  # Our layouts are templated so we can start with 
  # some custom information.
  # 
  def add_layouts
    app = "app/views/layouts/application.html.erb"
    template app, app
  end

  # We're going to automatically install backbone unless 
  # the user has disabled it
  # 
  def add_js_framework
    if @config.javascripts_helpers.include?(:backbone)
      directory(
        "app/assets/javascripts/backbone",
        "app/assets/javascripts"
      )
    end
  end

  # Next, we need to replace our application.js file to add backbone and its
  # dependencies, along with our default scripts.
  # 
  def add_js_manifest
    app_js = "app/assets/javascripts/application.js"
    remove_file app_js
    template "#{app_js}.erb", app_js
    gsub_file app_js, /\n\n+?/, "\n"
  end

  # Don't forget about modernizr! This is where all the other vendor scripts
  # should be added, although today we only use Modernizr.
  # 
  # Modernizr is called from the application layout since it is
  # automatically added.
  # 
  def add_js_libraries
    modernizr = "vendor/assets/javascripts/modernizr.js"
    copy_file modernizr, modernizr
  end

  # Install Bones unless the user has disabled it
  # 
  def add_style_framework
    if @config.stylesheets_helpers.include?(:bones)
      generate "bones:install"
    end
  end

  # Add our application.scss file. Since we don't know what 
  # file exists, we look for and delete all and replace 
  # with ours.
  # 
  def add_public_manifest
    ['css','scss','scss.css'].each do |ext| 
      file = "app/assets/stylesheets/application.#{ext}" 
      remove_file(file) if File.exists?(file)
    end
    manifest_file = "app/assets/stylesheets/application.scss"
    template manifest_file, manifest_file
  end

  # Now we need to add our styles. We begin here by adding our vendor styles
  # that are not already available via a gem.
  # 
  def add_vendor_styles
    normalize = "vendor/assets/stylesheets/normalize.scss"
    template normalize, normalize
  end

  def install_devise
    generate "devise:install"
  end

  def add_devise_user_model
    generate "devise User"
  end

  def add_user_model_file
    copy_file "app/models/user.rb", "app/models/user.rb", :force => true
  end

  # def migrate_and_annotate
  #   rake "db:migrate"
  #   run_cmd "#{be} annotate"
  # end

  def add_application_controller_redirects
    insert_into_file(
      "app/controllers/application_controller.rb",
      template_snippet("app/controllers/application_controller.rb"),
      :after => ":exception"
    )
  end

  private

    def gem_root
      Gem::Specification.find_by_name("cambium").gem_dir
    end

    def help_message(file)
      puts File.read("#{gem_root}/lib/help/#{file}.txt")
    end

end
