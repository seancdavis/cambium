require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class AdminGenerator < Rails::Generators::Base
      desc "Setup app files for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Default Public Controller

      def add_home_controller
        run_cmd "#{g} controller home index"
      end

      # ------------------------------------------ Routes

      def add_default_routes
        remove_file "config/routes.rb"
        template "config/routes.rb.erb", "config/routes.rb"
      end

      # ------------------------------------------ Public Views

      def add_public_views
        directory "app/views/application", "app/views/application"
      end

      # ------------------------------------------ Layouts

      def add_layouts
        @site_title = Rails.application.class.parent_name.humanize.titleize
        site_title = ask "\n#{set_color('App Title:', :green, :bold)} [default: #{@site_title}]"
        @site_title = site_title unless site_title.blank?
        
        app = "app/views/layouts/application.html.erb"
        remove_file app
        template app, app
      end

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

      # ------------------------------------------ Add Modernizr

      def add_modernizr
        modernizr = "vendor/assets/javascripts/modernizr.js"
        copy_file modernizr, modernizr
      end

      # ------------------------------------------ Public Styles

      def add_public_manifest
        ['css','scss','scss.css'].each { |ext| remove_file "app/assets/stylesheets/application.#{ext}" }
        template "app/assets/stylesheets/application.scss", 
          "app/assets/stylesheets/application.scss"
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
