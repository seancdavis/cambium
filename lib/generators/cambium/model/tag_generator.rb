require 'rake'
require 'rails/generators'

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
        run_cmd "#{g} model Tag name ci_name slug"
        run_cmd "#{g} model Tagging tag_id:integer taggable_id:integer taggable_type"
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
        run_cmd "#{rake} db:migrate"
        run_cmd "#{be} annotate"
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
          match = ask("CONFIRM #{question}")
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
