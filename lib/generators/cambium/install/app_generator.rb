require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Install
    class AppGenerator < Rails::Generators::Base
      desc "Setup app files for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      # Add a default public controller, so we have a working home page when
      # we're done.
      # 
      def add_home_controller
        generate "controller home index"
        gsub_file("config/routes.rb", /\ \ get\ \'home\/index\'\n\n/, '')
      end

      # Add our default routes, ommitting admin routes (which are added via the
      # admin generator)
      # 
      def add_default_routes
        insert_into_file(
          "config/routes.rb",
          file_contents("config/app_routes.rb"),
          :after => "Rails.application.routes.draw do"
        )
      end

      # Add our default public views
      # 
      def add_public_views
        directory "app/views/application"
        directory "app/views/home", :force => true
      end

      # Our layouts are templated so we can start with some custom information.
      # 
      def add_layouts
        @site_title = Rails.application.class.parent_name.humanize.titleize
        site_title = ask "\n#{set_color('App Title:', :green, :bold)} [default: #{@site_title}]"
        @site_title = site_title unless site_title.blank?
        
        app = "app/views/layouts/application.html.erb"
        remove_file app
        template app, app
      end

      # Backbone.js is our default javascript framework. We don't yet have an
      # option to ignore, so here we automatically install it.
      # 
      def install_backbone
        directory "app/assets/javascripts/backbone",
          "app/assets/javascripts"
      end

      # Next, we need to replace our application.js file to add backbone and its
      # dependencies, along with our default scripts.
      # 
      def default_application_js
        app_js = "app/assets/javascripts/application.js"
        remove_file app_js
        template app_js, app_js
      end

      # Don't forget about modernizr! This is where all the other vendor scripts
      # should be added, although today we only use Modernizr.
      # 
      # Modernizr is called from the application layout since it is
      # automatically added.
      # 
      def add_other_vendor_javascripts
        modernizr = "vendor/assets/javascripts/modernizr.js"
        copy_file modernizr, modernizr
      end

      # Now we need to add our styles. We begin here by adding our vendor styles
      # that are not already available via a gem.
      # 
      def add_vendor_styles
        normalize = "vendor/assets/stylesheets/normalize.scss"
        template normalize, normalize
      end

      # Once we have the files and gems we need, we can add our public manifest
      # file. We ask the user if they are ok with us deleting theirs.
      # 
      # Note: Injecting seems easier here, and it would be, but we can't predict
      # the name of this file, which is why we don't do it. It could be done
      # with a longer method.
      # 
      def add_public_manifest
        q = "\nWe're going to add our default application.scss file and remove yours. Is that ok?"
        if yes? q
          ['css','scss','scss.css'].each { |ext| remove_file "app/assets/stylesheets/application.#{ext}" }
        end
        template "app/assets/stylesheets/application.scss", 
          "app/assets/stylesheets/application.scss"
      end

      # If we have the user model generated, then we will try to create a
      # default user.
      # 
      def add_default_user
        if class_exists?('User')
          create_user
        else
          msg = "\nUser model does not exist yet. If you want to use Cambium "
          msg += "to add a user model, then you can run:\n"
          say set_color(msg, :yellow, :bold)
          say "   $ bundle exec rake cambium:model:user\n\n" 
          msg = "and Cambium will handle the installation of Devise.\n"
          say set_color(msg, :yellow, :bold)
        end
      end

      # Add some gems to the gemfile, but don't install (we've been running into
      # dependency issues)
      # 
      def add_application_gems
        gems = [
          'unicorn-rails',
          'jquery-rails',
          'uglifier',
          'sass-rails',
          'bourbon',
          'coffee-rails',
          'backbone-on-rails'
        ]
        add_gems_to_gemfile(gems)
        added_gems = []
        gems.each { |g| added_gems << g unless gem_exists?(g) }
        gemfile_update_notification(added_gems)
      end

      # ------------------------------------------ Private Methods

      private

        # create_user is down here because it can then keep looping until a
        # valid record is created.
        # 
        def create_user
          email = confirm_ask "#{set_color('Default User Email', :green, :bold)}:"
          password = confirm_ask "#{set_color('Default User Password', :green, :bold)}:"
          u = User.new(
            :email => email,
            :password => password, 
            :password_confirmation => password,
          )
          u.is_admin = true if u.respond_to?(:is_admin)
          if u.save
            say "User created successfully!"
          else
            create_user
          end
        end

    end
  end
end
