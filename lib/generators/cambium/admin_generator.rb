require 'rake'
require 'rails/generators'
require 'fileutils'
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

    # Add another migration for user profile fields
    #
    def add_user_profile
      generate "migration add_user_profile_fields_to_users name:string"
    end

    # Add admin sidebar file to the project
    #
    def add_admin_routes
      ['sidebar','users','pages','documents'].each do |file|
        template "config/admin/#{file}.yml", "config/admin/#{file}.yml"
      end
    end

    # Add migration for paper_trail versions
    #
    def add_paper_trail
      generate 'paper_trail:install'
      Dir.glob("#{Rails.root}/app/models/*.rb").each do |f|
        insert_into_file f.to_s, :after => "ActiveRecord::Base\n" do
          "  # ------------------------------------------ Plugins\n" +
          "  has_paper_trail\n"
        end
      end
    end

    # Add migration for pg_search
    #
    def add_pg_search
      generate 'pg_search:migration:multisearch'
      help_message('pg_search_post_install')
    end

    # Add pg_search to users
    #
    def add_user_search
      insert_into_file(
        "#{Rails.root}/app/models/user.rb", :after => "---- Plugins\n"
      ) do
        "  include PgSearch\n" +
        "  multisearchable :against => [:name, :email]\n"
      end
    end

    # Adds a manifest SCSS file to the project, so the
    # developer can override any admin styles with creating
    # a new layout
    #
    def add_css_override
      file = "app/assets/stylesheets/admin/admin.scss"
      template(file, file)
    end

  end
end
