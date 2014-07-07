require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class ModelsGenerator < Rails::Generators::Base
      desc "Setup models for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ User Model

      def add_admin_column_to_users
        unless User.column_names.include?('is_admin')
          run_cmd "#{g} migration add_is_admin_to_users is_admin:boolean"
          run_cmd "#{rake} db:migrate"
        end
      end

      def add_user_model_file
        remove_file "app/models/user.rb"
        template "app/models/user.rb", "app/models/user.rb"
        run_cmd "#{be} annotate"
      end

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
