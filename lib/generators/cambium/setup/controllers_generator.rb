require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class ControllersGenerator < Rails::Generators::Base
      desc "Setup controllers for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Default Public Controller

      def add_home_controller
        run_cmd "#{g} controller home index"
      end

      # ------------------------------------------ Admin Controller

      def add_admin_controller
        template "app/controllers/admin_controller.rb", 
          "app/controllers/admin_controller.rb"
      end

      # ------------------------------------------ Admin Users Controller

      def add_admin_users_controller
        template "app/controllers/admin/users_controller.rb", 
          "app/controllers/admin/users_controller.rb"
      end

      # ------------------------------------------ Routes

      def add_default_routes
        remove_file "config/routes.rb"
        template "config/routes.rb.erb", "config/routes.rb"
      end

      # ------------------------------------------ Log In/Out Redirects

      def add_application_controller_redirects
        insert_into_file(
          "app/controllers/application_controller.rb",
          file_contents("app/controllers/application_controller.rb"),
          :after => ":exception"
        )
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
