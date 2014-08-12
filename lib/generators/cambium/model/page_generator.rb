require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Model
    class PageGenerator < Rails::Generators::Base
      desc "Add pages to your project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Model Concern

      def add_model_concerns
        copy_file "app/models/concerns/publishable.rb", "app/models/concerns/publishable.rb"
        copy_file "app/models/concerns/slug.rb", "app/models/concerns/slug.rb"
      end

      # ------------------------------------------ Add Model Templates

      def add_model_files
        model_path = "app/models/page.rb"
        template(model_path, model_path)
      end

      # ------------------------------------------ Add Migration Templates

      def add_migration_files
        template(
          'db/migrate/create_pages.rb',
          "db/migrate/#{timestamp}_create_pages.rb"
        )
      end

      # ------------------------------------------ Add App config

      def add_application_config
        application 'config.template_directory = "#{Rails.root}/app/views/page_templates"'
      end

      # ------------------------------------------ Add page templaes

      def add_page_templates
        directory('app/views/page_templates','app/views/page_templates')
      end

      # ------------------------------------------ Add Controller Templates

      def add_controller_files
        controller_path = "app/controllers/pages_controller.rb"
        template(controller_path, controller_path)
      end

      # ------------------------------------------ Migrate & Annotate

      def migrate_and_annotate
        rake "db:migrate"
        run_cmd "#{be} annotate"
      end

      # ------------------------------------------ User output
      # This is kind of a cop out in leu of appending to the *end* of routes.rb
      def notes_to_user
        puts "\n== Add the following to the end of your config/routes.rb file ================="
        puts "get '/:slug', :to => 'pages#show', :as => 'page'"
        puts "\n"
      end

    end
  end
end
