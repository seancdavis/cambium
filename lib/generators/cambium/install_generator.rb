require 'rake'
require 'rails/generators'

module Cambium
  class InstallGenerator < Rails::Generators::Base
    desc "Add Cambium config file to your initializers."

      source_root File.expand_path('../../templates', __FILE__)

      # Copy our Cambium config file into the project's config/initializers
      # directory.
      # 
      def add_config_file
        config_file = "config/initializers/cambium.rb"
        copy_file config_file, config_file
      end

  end
end
