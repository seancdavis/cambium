require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  class AppGenerator < Rails::Generators::Base

    desc "Add all the pieces to your application per your configuration."

    source_root File.expand_path('../../templates', __FILE__)

    class_option(
      :config_check,
      :type => :boolean,
      :default => true,
      :description => "Verify config at config/initializers/cambium.rb"
    )

    # If there is no configuration file tell the user to run
    # that generator first (unless user has manually
    # overridden).
    #
    def verify_configuration
      if options.config_check?
        unless File.exists?("#{Rails.root}/config/initializers/cambium.rb")
          help_message('cambium_prereqs')
          exit
        end
      end
    end

    # Wrap our config values up in an easier-to-type
    # variable
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

    # Add settings to application config file
    # (config/application.rb)
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
      remove_file ".gitignore"
      template "gitignore", ".gitignore"
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
    # We don't override routes here in case the user started
    # to edit their routes file before running this generator.
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
      directory("app/assets/javascripts", "app/assets/javascripts")
    end

    # Next, we need to replace our application.js file to add
    # backbone and its dependencies, along with our default
    # scripts.
    #
    def add_js_manifest
      app_js = "app/assets/javascripts/application.js"
      remove_file app_js
      app_js += ".coffee"
      template app_js, app_js
    end

    # Add our application.scss file. Since we don't know what
    # file exists, we look for and delete all and replace with
    # ours.
    #
    def add_public_manifest
      ['css','scss','scss.css'].each do |ext|
        file = "app/assets/stylesheets/application.#{ext}"
        remove_file(file) if File.exists?(file)
      end
      manifest_file = "app/assets/stylesheets/application.scss"
      template manifest_file, manifest_file
    end

    # Go through standard Devise installation
    #
    def install_devise
      generate "devise:install"
    end

    # Add a User model
    #
    def add_devise_user_model
      generate "devise User"
    end

    # Copy our custom user model template into the app
    #
    def add_user_model_file
      copy_file "app/models/user.rb", "app/models/user.rb", :force => true
    end

    # Override Devise's default redirects and sign in/out
    #
    def add_application_controller_redirects
      insert_into_file(
        "app/controllers/application_controller.rb",
        template_snippet("app/controllers/application_controller.rb"),
        :after => ":exception"
      )
    end

    # Install Simple Form automatically
    #
    def install_simple_form
      generate "simple_form:install"
    end

    # Add ruby class overrides and additions
    #
    def add_ruby_class_overrides
      template "config/initializers/_hash.rb", "config/initializers/_hash.rb"
    end

    # Add our settings and private settings files
    #
    def add_settings_files
      template "config/initializers/_settings.rb",
        "config/initializers/_settings.rb"
      ['settings','private'].each do |s|
        template "config/#{s}.yml", "config/#{s}.yml"
      end
    end

    # Add the custom seed generator, which loads content
    # from CSV into the database.
    #
    def add_seed_generator
      remove_file "db/seeds.rb"
      template "db/seeds.rb", "db/seeds.rb"
    end

  end
end
