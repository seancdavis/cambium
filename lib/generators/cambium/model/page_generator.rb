require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Model
    class PageGenerator < Rails::Generators::Base
      desc "Add pages to your project"

      source_root File.expand_path('../../templates', __FILE__)

      # Since we're using images, we need to make sure the image generator has
      # already been run.
      # 
      def set_dependencies
        check_dependencies(['cambium:install:admin','cambium:model:image'])
      end

      # We need a couple concerns, so we add them here unless they are already
      # part of the project.
      # 
      def add_concerns
        add_model_concerns(['publishable', 'slug'])
      end

      # Add our model file.
      # 
      def add_model_files
        template("app/models/page.rb", "app/models/page.rb")
      end

      # Since we have to customize the up/down methods in the migration, we
      # don't generate the model, we just copy an interpreted template.
      # 
      def add_migration_files
        template(
          "db/migrate/create_pages.rb.erb",
          "db/migrate/#{timestamp}_create_pages.rb"
        )
        migrate_and_annotate
      end

      # We are setting a global template directory for reference throughout the
      # project.
      # 
      def add_application_config
        application 'config.template_directory = "#{Rails.root}/app/views/page_templates"'
      end

      # We add our page templates directory and our default template.
      # 
      def add_page_templates
        directory('app/views/page_templates','app/views/page_templates')
      end

      # We have two controllers here -- one for the app and one for the admin.
      # We'll add them both instead of generating them since they are
      # customized.
      # 
      def add_controller_files
        template("app/controllers/pages_controller.rb", 
          "app/controllers/pages_controller.rb")
        template("app/controllers/admin/pages_controller.rb", 
          "app/controllers/admin/pages_controller.rb")
      end

      # We add the customized views that override the default admin views, while
      # the app views are driven by the page template
      # 
      def add_admin_views
        directory("app/views/admin/pages", "app/views/admin/pages")
      end

      # We need to add routes to routes file for the app and the admin. We
      # expect to see an admin, so we don't have a check, but we do need the
      # public route. Since the contents of the routes file are variable, we
      # have a check and notify the user if we can't find what we need.
      # 
      def add_routes
        # App
        insert_into_file(
          "config/routes.rb",
          "get '/:slug', :to => 'pages#show', :as => 'page'\n\n  ",
          :before => /root\ (.*)\n/
        )
        if File.read(Rails.root.join('config','routes.rb')).include?('/:slug')
          uncomment_lines(
            Rails.root.join('config','routes.rb'),
            /get\ \'\/\:slug/
          )
        else
          add_routes_manually
        end
        # Admin
        insert_into_file(
          "config/routes.rb",
          "    resources :pages, :except => [:show]\n",
          :after => /namespace\ \:admin(.*)\n/
        )
      end

      # In the admin helper, we can add a link and an icon to the sidebar. The
      # easiest way to do this is to add it to the top. The user can move if
      # they'd like.
      # 
      def add_admin_icon
        insert_into_file(
          "app/helpers/admin_helper.rb",
          file_contents('_partials/pages/admin_icon.rb'),
          :after => /items\ \=\ \[\n/
        )
      end

      private

        # If we couldn't find a root route in the config file, then we tell the
        # user to add the routes manually.
        # 
        def add_routes_manually
          say set_color(
            "\nAdd the following to the end of your config/routes.rb file:\n",
            :yellow,
            :bold
          )
          say "    get '/:slug', :to => 'pages#show', :as => 'page'\n"
        end

    end
  end
end
