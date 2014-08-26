require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Model
    class PageGenerator < Rails::Generators::Base
      desc "Add pages to your project"

      # Template root
      # 
      source_root File.expand_path('../../templates', __FILE__)

      # Add model concerns
      # 
      def add_concerns
        concerns = ['publishable', 'slug']
        add_model_concerns(concerns)
      end

      # Add the actual model file
      # 
      def add_model_files
        model_path = "app/models/page.rb"
        template(model_path, model_path)
      end

      # Add migration templates
      # 
      def add_migration_files
        template(
          "db/migrate/create_pages.rb.erb",
          "db/migrate/#{timestamp}_create_pages.rb"
        )
      end

      # Application config
      # 
      def add_application_config
        application 'config.template_directory = "#{Rails.root}/app/views/page_templates"'
      end

      # Add page templaes
      # 
      def add_page_templates
        directory('app/views/page_templates','app/views/page_templates')
      end

      # Add controller templates
      # 
      def add_controller_files
        controller_path = "app/controllers/pages_controller.rb"
        template(controller_path, controller_path)
      end

      # Migrate & Annotate
      # 
      def migrate_and_annotate
        rake "db:migrate"
        run_cmd "#{be} annotate"
      end

      # Add routes
      # 
      def add_routes
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
