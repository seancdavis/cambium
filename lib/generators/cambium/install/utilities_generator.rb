require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Install
    class UtilitiesGenerator < Rails::Generators::Base
      desc "Setup utilities for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Model Concerns

      def add_model_concerns
        [
          'idx',
          'name',
          'publishable',
          'slug',
          'title',
        ].each do |concern|
          copy_file "app/models/concerns/#{concern}.rb", 
            "app/models/concerns/#{concern}.rb"
        end
      end

      # ------------------------------------------ Settings Files

      def add_settings_files
        template "config/initializers/_settings.rb", 
          "config/initializers/_settings.rb"
        ['settings','settings_private','settings_private.sample'].each do |s|
          template "config/#{s}.yml", "config/#{s}.yml"
        end
      end

      # ------------------------------------------ Seeds

      def add_seed_generator
        remove_file "db/seeds.rb"
        template "db/seeds.rb", "db/seeds.rb"
      end

      # ------------------------------------------ Rake Tasks

      def add_rake_tasks
        ['db','rename'].each do |task|
          template "lib/tasks/#{task}.rake", "lib/tasks/#{task}.rake"
        end
      end

    end
  end
end
