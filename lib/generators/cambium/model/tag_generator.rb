require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Model
    class TagGenerator < Rails::Generators::Base
      desc "Add tags to your project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Model Concern

      def add_model_concern
        copy_file "app/models/concerns/tags.rb", "app/models/concerns/tags.rb"
      end

      # ------------------------------------------ Generate Models & Migrations

      def generate_models
        generate "model Tag name ci_name slug"
        generate "model Tagging tag_id:integer taggable_id:integer taggable_type"
      end

      # ------------------------------------------ Add Model Templates

      def add_model_files
        ['tag','tagging'].each do |file| 
          model_path = "app/models/#{file}.rb"
          remove_file(model_path)
          template(model_path, model_path)
        end
      end

      # ------------------------------------------ Migrate & Annotate

      def migrate_and_annotate
        rake "db:migrate"
        run_cmd "#{be} annotate"
      end

    end
  end
end
