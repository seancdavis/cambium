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

      # Admin controllers are added in this manner because we have controllers
      # in the directory which we do not want to copy over by default.
      # 
      def add_admin_controller
        copy_files [
          'admin_controller.rb',
          'admin/users_controller.rb'
        ], "app/controllers"
      end

      # Continuing from the previous method, we also need to individually copy
      # the view files over, since these default views have to site directly in
      # the app/views/admin folder, and can't be placed in a subdirectory.
      # 
      # Any new partial will have to be added here manually.
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

      # The admin layout gives us the customization we need to layout our CMS.
      # Here we ask the user for some input for those items that will vary from
      # project-to-project.
      # 
      def add_layouts
        @site_title = "#{Rails.application.class.parent_name.humanize.titleize} Admin"
        site_title = ask "\n#{set_color('Admin Title:', :green, :bold)} [default: #{@site_title}]"
        @site_title = site_title unless site_title.blank?
        admin = "app/views/layouts/admin.html.erb"
        template admin, admin
      end

      # Currently, all the helper methods are shoved into one file. The plan is
      # to break the methods out into individual helpers, namespaced under
      # admin.
      # 
      def add_admin_helper
        template "app/helpers/admin_helper.rb", 
          "app/helpers/admin_helper.rb"
      end

      # Like the app side, the admin uses the Backbone.js framework since it's
      # lightweight and easy-to-use. We've added several scripts to make your
      # CMS powerful right out of the box.
      # 
      def add_admin_javascripts
        directory "app/assets/javascripts/admin",
          "app/assets/javascripts/admin"
      end

      # Our admin styles use Bones, along with some customization on top of
      # Bones. Let's install these.
      # 
      def add_admin_styles
        directory "app/assets/stylesheets/admin",
          "app/assets/stylesheets/admin"
      end

      # Here we are adding the gems we will need for the admin. Many of these
      # are duplicates from the app gems, but that's ok, since we check to see
      # if they exist first.
      # 
      def add_application_gems
        gems = [
          'unicorn-rails',
          'jquery-rails',
          'uglifier',
          'sass-rails',
          'bourbon',
          'coffee-rails',
          'backbone-on-rails',
          'bones-rails',
          'jbuilder',
          'pickadate-rails',
          'simple_form',
          'wysihtml5-rails',
          'jquery-fileupload-rails',
        ]
        add_gems_to_gemfile(gems)
        added_gems = []
        gems.each { |g| added_gems << g unless gem_exists?(g) }
        gemfile_update_notification(added_gems)
      end

    end
  end
end
