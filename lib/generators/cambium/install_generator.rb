require 'cambium'

module Cambium
  class InstallGenerator < Generator
    desc "Add Cambium config file to your initializers."

    source_root templates_dir

    def add_config_file
      puts 'HELLO!!!!'
      template "config/initializers/cambium.rb"
    end

  end
end
