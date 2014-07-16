require 'rake'
require 'rails/generators'

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
          'tags',
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

      # ------------------------------------------ Private Methods

      private

        def run_cmd(cmd, options = {})
          print_table(
            [
              [set_color("run", :green, :bold), cmd]
            ],
            :indent => 9
          )
          if options[:quiet] == true
            `#{cmd}`
          else
            system(cmd)
          end
        end

        def template_file(name)
          File.expand_path("../../templates/#{name}", __FILE__)
        end

        def file_contents(template)
          File.read(template_file(template))
        end

        def be
          "bundle exec"
        end

        def g
          "#{be} rails g"
        end

        def rake
          "#{be} rake"
        end

        def confirm_ask(question)
          answer = ask("\n#{question}")
          match = ask("Confirm: #{question}")
          if answer == match
            answer
          else
            say set_color("Did not match.", :red)
            confirm_ask(question)
          end
        end

    end
  end
end
