require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class JavascriptsGenerator < Rails::Generators::Base
      desc "Setup controllers for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Public Setup

      def install_backbone
        run_cmd "#{g} backbone:install"
      end

      def default_application_js
        app_js = "app/assets/javascripts/application.js"
        remove_file app_js
        template app_js, app_js
      end

      def rename_backbone_root
        app_name = Rails.application.class.parent_name.underscore.downcase
        remove_file "app/assets/javascripts/backbone/#{app_name}.js.coffee"
        template "app/assets/javascripts/backbone/app.js.coffee", 
          "app/assets/javascripts/backbone/app.js.coffee"
      end

      # ------------------------------------------ Public Files

      def add_public_router
        remove_file "app/assets/javascripts/backbone/routers/.gitkeep"
        template "app/assets/javascripts/backbone/routers/router.js.coffee", 
          "app/assets/javascripts/backbone/routers/router.js.coffee"
      end

      def add_default_view
        remove_file "app/assets/javascripts/backbone/views/.gitkeep"
        template "app/assets/javascripts/backbone/views/default_helpers.js.coffee", 
          "app/assets/javascripts/backbone/views/default_helpers.js.coffee"
      end

      # ------------------------------------------ Admin Setup

      def add_admin_files
        directory "app/assets/javascripts/admin",
          "app/assets/javascripts/admin"
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
