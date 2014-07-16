require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class AdminGenerator < Rails::Generators::Base
      desc "Setup admin files for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

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

      # ------------------------------------------ Admin Views

      def add_admin_views
        directory "app/views/admin", "app/views/admin"
      end

      # ------------------------------------------ Layouts

      def add_layouts
        @site_title = "#{Rails.application.class.parent_name.humanize.titleize} CMS"
        admin = "app/views/layouts/admin.html.erb"
        template admin, admin
      end

      # ------------------------------------------ Admin Helper

      def add_admin_helper
        template "app/helpers/admin_helper.rb", 
          "app/helpers/admin_helper.rb"
      end

      # ------------------------------------------ Admin Setup

      def add_admin_files
        directory "app/assets/javascripts/admin",
          "app/assets/javascripts/admin"
      end

      # ------------------------------------------ Admin Styles

      def add_admin_styles
        directory "app/assets/stylesheets/admin",
          "app/assets/stylesheets/admin"
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
