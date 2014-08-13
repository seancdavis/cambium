require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Model
    class PostGenerator < Rails::Generators::Base
      desc "Add blog posts to your project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Model Concern

      def add_model_concerns
        copy_file "app/models/concerns/publishable.rb", "app/models/concerns/publishable.rb"
        copy_file "app/models/concerns/slug.rb", "app/models/concerns/slug.rb"
        copy_file "app/models/concerns/tags.rb", "app/models/concerns/tags.rb"
      end

      # ------------------------------------------ Add Model Templates

      def add_model_files
        model_path = "app/models/post.rb"
        template(model_path, model_path)
      end

      # ------------------------------------------ Add Migration Templates

      def add_migration_files
        template(
          'db/migrate/create_posts.rb',
          "db/migrate/#{timestamp}_create_posts.rb"
        )
      end

      # ------------------------------------------ Add Controller Templates

      def add_controller_files
        controller_path = "app/controllers/posts_controller.rb"
        template(controller_path, controller_path)
      end

      # ------------------------------------------ Add View Templates

      def add_view_files
        view_path = "app/views/posts"
        directory(view_path, view_path)
      end

      # ------------------------------------------ Migrate & Annotate

      def migrate_and_annotate
        rake "db:migrate"
        run_cmd "#{be} annotate"
      end

      # ------------------------------------------ User output
      # This is kind of a cop out in leu of appending to the *end* of routes.rb
      def notes_to_user
        puts "\n== Don't forget to add routes for blog posts ================="
        puts "get '/news', :to => 'posts#index', :as => 'posts'"
        puts "get '/news/:slug', :to => 'posts#show', :as => 'post'"
        puts "\n"
      end

    end
  end
end
