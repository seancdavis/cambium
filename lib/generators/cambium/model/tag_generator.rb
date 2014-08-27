require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Model
    class TagGenerator < Rails::Generators::Base
      desc "Add tags to your project"

      source_root File.expand_path('../../templates', __FILE__)

      # Make sure the tags concern is in the project. If not, add it!
      # 
      def add_concerns
        add_model_concerns(['tags'])
      end

      # Since the models are simple enough, we can generate from the command
      # line.
      # 
      def generate_models
        generate "model Tag name ci_name slug"
        generate "model Tagging tag_id:integer taggable_id:integer taggable_type"
      end

      # Add our customized model files. 
      # 
      def add_model_files
        ['tag','tagging'].each do |file|
          template("app/models/#{file}.rb", "app/models/#{file}.rb")
        end
      end

      def finish_up
        migrate_and_annotate
      end

    end
  end
end
