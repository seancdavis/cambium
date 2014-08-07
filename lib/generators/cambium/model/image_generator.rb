require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Model
    class ImageGenerator < Rails::Generators::Base
      desc "Create a simple image model"

      source_root File.expand_path('../../templates', __FILE__)

      # Install gems we need for images
      # 
      def install_dependencies
        install_gem 'carrierwave'
        install_gem 'rmagick', :require => 'RMagick'
      end

      # Generate our blank model file and prepared migration
      # 
      def generate_model
        generate "model Image filename"
      end

      # Add our pre-built model file
      # 
      def add_model_files
        model_path = "app/models/image.rb"
        copy_file model_path, model_path, :force => true
      end

      # Add uploader
      # 
      def add_uploaders
        generate "uploader Image"
        uploader_path = "app/uploaders/image_uploader.rb"
        copy_file uploader_path, uploader_path, :force => true
      end

      # Add our image cropper model concern
      # 
      def add_model_concerns
        add_model_concern 'image_cropper'
      end

      # Migrate and annotate
      # 
      def finish_up
        migrate_and_annotate
      end

    end
  end
end
