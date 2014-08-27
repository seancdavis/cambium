require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Model
    class ImageGenerator < Rails::Generators::Base
      desc "Create a simple image model"

      source_root File.expand_path('../../templates', __FILE__)

      # Let's make sure we have the admin setup already.
      # 
      def set_dependencies
        check_dependencies(['cambium:install:admin'])
      end

      # Install gems we need for images
      # 
      def install_gem_dependencies
        install_gem 'carrierwave'
        install_gem 'rmagick', :require => 'RMagick'
      end

      # Since the Image model is so simple, we can generate it from the command
      # line instead of copying templates.
      # 
      def generate_model
        generate "model Image filename"
      end

      # Add our pre-built model file
      # 
      def add_model_files
        copy_file("app/models/image.rb", "app/models/image.rb", :force => true)
      end

      # Add our image uploader, which uses CarrierWave
      # 
      def add_uploaders
        generate "uploader Image"
        uploader_path = "app/uploaders/image_uploader.rb"
        copy_file uploader_path, uploader_path, :force => true
      end

      # Add our image cropper model concern. Currently, we don't have the
      # cropping tool functional within the admin.
      # 
      def add_model_concerns
        add_model_concern 'image_cropper'
      end

      # Before we finish up, we need to add our admin files.
      # 
      def add_admin_files
        template("app/controllers/admin/images_controller.rb", 
          "app/controllers/admin/images_controller.rb")
        directory("app/views/admin/images", "app/views/admin/images")
      end

      def finish_up
        migrate_and_annotate
      end

    end
  end
end
