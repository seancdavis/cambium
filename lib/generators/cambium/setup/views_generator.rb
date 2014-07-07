require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class ViewsGenerator < Rails::Generators::Base
      desc "Setup views for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Admin Views

      def add_admin_views
        directory "app/views/admin", "app/views/admin"
      end

      # ------------------------------------------ Layouts

      def add_layouts
        app = "app/views/layouts/application.html.erb"
        admin = "app/views/layouts/admin.html.erb"
        remove_file app
        template app, app
        template admin, admin
      end

      # ------------------------------------------ Public Views

      def add_public_views
        directory "app/views/application", "app/views/application"
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
