require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Install
    class AdminGenerator < Rails::Generators::Base
      desc "Setup admin files for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Admin Controllers

      def add_admin_controller
        template "app/controllers/admin_controller.rb", 
          "app/controllers/admin_controller.rb"
        directory "app/controllers/admin", "app/controllers/admin"
      end

      # ------------------------------------------ Admin Views

      def add_admin_views
        directory "app/views/admin", "app/views/admin"
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
