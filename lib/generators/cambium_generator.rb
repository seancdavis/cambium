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

  private

    def gem_root
      Gem::Specification.find_by_name("cambium").gem_dir
    end

    def help_message(file)
      puts File.read("#{gem_root}/lib/help/#{file}.txt")
    end

end
