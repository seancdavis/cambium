require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  class AdminGenerator < Rails::Generators::Base

    desc "Installs the base for a CMS within your rails application."

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

end
