require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Install
    class ConfigGenerator < Rails::Generators::Base
      desc "Setup config files for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      # Initialize git repository. If repo was already initialized, repo is
      # reinitialized, but that shouldn't hurt anything.
      # 
      def git_init
        run_cmd "git init"
      end

      # Set vars to use throughout this generator
      # 
      def cambium_setup
        @config = {
          :db => {},
          :app => {}
        }
      end

      # Read existing project files to set default config values
      # 
      def auto_config
        # read Gemfile
        File.open("#{Rails.root}/Gemfile") do |f|
          f.each_line do |line|
            # find database adapter
            if line.include?("'mysql2'")
              @config[:db][:adapter] = "mysql2"
            elsif line.include?("'pg'")
              @config[:db][:adapter] = "pg"
            elsif line.include?("'sqlite3'")
              @config[:db][:adapter] = "sqlite3"
            end
            # find rails version
            if line.match(/gem\ \'rails\'/)
              @config[:app][:version] = line.gsub(/gem\ \'rails\'\,/, '').gsub(/\'/, '').strip
            end
          end
        end
        # Find the application class name
        @config[:app][:name] = Rails.application.class.parent_name
      end

      # These next few methods let the user adjust the default config if they
      # wish. Otherwise, we use default values from the previous method.
      # 
      # --------
      # 
      # Set correct database adapter.
      # 
      # Note: If the user wants to change the adapter, we *could* change the
      # adapter on the fly and install the new one here. Instead, we tell the
      # user what to do and exit. This make absolutely sure we've gotten rid of
      # the original adapter in the Gemfile and added the new one.
      # 
      def set_database_adapter
        if @config[:db][:adapter].present?
          if yes?("\nCambium, in all its wisdom, thinks your database adapter as #{set_color(@config[:db][:adapter], :green, :bold)}. Is this correct? [yes, no]")
            say("Oh, goodie! Moving on...")
          else
            new_adapter = ask("What would you prefer?", :limited_to => ['mysql2','pg','sqlite3'])
            unless new_adapter == @config[:db][:adapter]
              say set_color("\nPlease add:", :red, :bold)
              say "\n    gem '#{new_adapter}'"
              say set_color("\nto your Gemfile. Then run `bundle install` and `bundle exec cambium setup`.", :red, :bold)
              exit
            end
          end
        end
      end

      # Set the database base name (where we append "_#{stage}" to each stage)
      # 
      def set_database_name
        @config[:db][:name] = @config[:app][:name].underscore.downcase
        db_name = ask "\n#{set_color('Database Base Name:', :green, :bold)} [default: #{@config[:db][:name]}]"
        @config[:db][:name] = db_name unless db_name.blank?
      end

      # Set database credentials
      # 
      def set_database_creds
        @config[:db][:user] = confirm_ask("#{set_color('Database User', :green, :bold)}: [leave blank for no user]")
        if @config[:db][:user].present?
          @config[:db][:password] = confirm_ask("#{set_color('Database Password', :green, :bold)}: [leave blank for no password]")
        else
          @config[:db][:password] = ''
        end
      end

      # Set root URL (for mailers)
      # 
      def set_root_url
        # development
        @config[:app][:dev_url] = ask("\n#{set_color('Development URL', :green, :bold)}: [leave blank for localhost:3000]")
        @config[:app][:dev_url] = 'localhost:3000' if @config[:app][:dev_url].blank?
        environment(
          "config.action_mailer.default_url_options = { :host => '#{@config[:app][:dev_url]}' }", 
          :env => "development"
        )
        # production
        @config[:app][:prod_url] = ask("#{set_color('Production URL', :green, :bold)}: [leave blank for localhost:3000]")
        @config[:app][:prod_url] = 'localhost:3000' if @config[:app][:prod_url].blank?
        environment(
          "config.action_mailer.default_url_options = { :host => '#{@config[:app][:prod_url]}' }", 
          :env => "production"
        )
        environment(
          "config.assets.precompile += %w( admin/admin.css admin/admin.js admin/wysihtml5.css modernizr.js )",
          :env => "production"
        )
      end

      # Add settings to application config file (config/application.rb)
      # 
      def add_application_config
        environment { file_contents("config/application.rb") }
      end

      # Assets initializer for Rails 4.1+
      # 
      def add_assets_initializer
        template "config/initializers/assets.rb", 
          "config/initializers/assets.rb"
      end

      # Create database based on custom config
      # 
      def setup_database
        copy_file "#{Rails.root}/config/database.yml", "config/database.sample.yml"
        remove_file "config/database.yml"
        template "config/database.#{@config[:db][:adapter]}.yml.erb", "config/database.yml"
        rake "db:create"
        rake "db:migrate"
      end

      # Add custom gitignore file
      # 
      def add_gitignore
        remove_file ".gitignore"
        template "gitignore", ".gitignore"
      end

      # Outgoing message
      # 
      def tell_user_we_are_done
        say "\n#{set_color('Config completed!', :green, :bold)}"
      end

    end
  end
end
