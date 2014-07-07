require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class StylesheetsGenerator < Rails::Generators::Base
      desc "Setup stylesheets for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Public Styles

      def add_public_manifest
        ['css','scss','scss.css'].each { |ext| remove_file "app/assets/stylesheets/application.#{ext}" }
        template "app/assets/stylesheets/application.scss", 
          "app/assets/stylesheets/application.scss"
      end

      # ------------------------------------------ Admin Styles

      def add_admin_styles
        directory "app/assets/stylesheets/admin",
          "app/assets/stylesheets/admin"
      end

      # ------------------------------------------ Add Modernizr

      def add_normalize
        normalize = "vendor/assets/stylesheets/normalize.scss"
        template normalize, normalize
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
