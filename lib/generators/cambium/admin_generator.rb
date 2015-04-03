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

    # Generate a migration so we can keep users from
    # accessing the admin if they don't have permission
    #
    def add_admin_migration
      generate "migration add_is_admin_to_users" # is_admin:boolean"
      Dir.glob("#{Rails.root.join('db','migrate')}/*.rb").each do |file|
        filename = file.split('/').last
        if filename =~ /is\_admin/
          insert_into_file(
            "db/migrate/#{filename}",
            "\n    add_column :users, :is_admin, :boolean, :default => false",
            :after => "def change"
          )
        end
      end
    end

    # Add admin sidebar file to the project
    #
    def add_admin_routes
      ['sidebar','users'].each do |file|
        template "config/admin/#{file}.yml", "config/admin/#{file}.yml"
      end
    end

  end
end
