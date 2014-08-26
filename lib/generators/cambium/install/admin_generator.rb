require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Install
    class AdminGenerator < Rails::Generators::Base
      desc "Setup admin files for new rails project"

      source_root File.expand_path('../../templates', __FILE__)
 
      def set_dependencies
        check_dependencies(['cambium:model:user'])
      end

      # Add base admin controllers
      # 
      def add_admin_controller
        copy_files [
          'admin_controller.rb',
          'admin/users_controller.rb'
        ], "app/controllers"
      end

      # Add base admin views
      # 
      def add_admin_views
        copy_files [
          '_buttons.html.erb',
          '_form.html.erb',
          '_title.html.erb',
          'edit.html.erb',
          'index.html.erb',
          'new.html.erb'
        ], "app/views/admin"
        directories ['shared','users'], "app/views/admin"
      end

      # ------------------------------------------ Layouts

      def add_layouts
        @site_title = "#{Rails.application.class.parent_name.humanize.titleize} Admin"
        site_title = ask "\n#{set_color('Admin Title:', :green, :bold)} [default: #{@site_title}]"
        @site_title = site_title unless site_title.blank?

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

    end
  end
end
