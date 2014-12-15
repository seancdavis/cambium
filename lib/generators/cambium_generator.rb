require 'rake'
require 'rails/generators'

class CambiumGenerator < Rails::Generators::Base

  desc "Add all the pieces to your application per your configuration."

  source_root File.expand_path('../templates', __FILE__)

  class_option(
    :config_check, 
    :type => :boolean, 
    :default => true, 
    :description => "Verify config at config/initializers/cambium.rb"
  )

  # If there is no configuration file tell the user to run that generator
  # first (unless user has manually overridden).
  # 
  def verify_configuration
    if options.config_check?
      unless File.exists?("#{Rails.root}/config/initializers/cambium.rb")
        help_message('cambium_prereqs')
        exit
      end
    end
  end

  private

    def gem_root
      Gem::Specification.find_by_name("cambium").gem_dir
    end

    def help_message(file)
      puts File.read("#{gem_root}/lib/help/#{file}.txt")
    end

end