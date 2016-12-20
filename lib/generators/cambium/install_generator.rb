require 'cambium'

module Cambium
  class InstallGenerator < Generator
    desc "Add Cambium config file to your initializers."

    source_root templates_dir

    class_option :thin_generators, :type => :boolean, :default => false,
                 :description => "Reduce the files Rails creates on generate"


    def add_config_file
      template "config/initializers/cambium.rb"
    end

    def add_application_config
      if options.thin_generators?
        environment { read_file("config/application.rb") }
      end
    end

  end
end
