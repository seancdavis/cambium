require 'rake'
require 'rails/generators'

module Cambium
  class GemfileGenerator < Rails::Generators::Base

    desc "Replace your existing Gemfile with Cambium's default Gemfile."

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

    # Here we figure out some of the more complicated logic
    # before rendering the Gemfile template
    #
    def resolve_options

      # database adapter
      db_adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
      case db_adapter
      when 'sqlite3'
        @db_gem = 'sqlite3'
      when 'mysql'
        @db_gem = 'mysql2'
      when 'postgresql'
        @db_gem = 'pg'
      end

      # rails version
      @rails_version = `bundle exec rails -v`.to_s.split(' ').last

      # assets
      @stylesheets = Cambium.configuration.stylesheets_helpers
      @javascripts = Cambium.configuration.javascripts_helpers
      @uploader = Cambium.configuration.uploader

    end

    # Move our default Gemfile to the project's Gemfile.
    #
    def add_config_file
      template "Gemfile.erb", "Gemfile", :force => true
      gsub_file "Gemfile", /\n\n\n+?/, "\n\n"
    end

    private

      def gem_root
        Gem::Specification.find_by_name("cambium").gem_dir
      end

      def help_message(file)
        puts File.read("#{gem_root}/lib/help/#{file}.txt")
      end

  end
end
