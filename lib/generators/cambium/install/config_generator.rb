require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Install
    class ConfigGenerator < Rails::Generators::Base
      desc "Setup config files for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Config

      def git_init
        run_cmd "git init"
      end

      def cambium_setup
        @config = {
          :db => {},
          :app => {}
        }
      end

      def auto_config
        # Read Gemfile
        File.open("#{Rails.root}/Gemfile") do |f|
          f.each_line do |line|
            # Database
            if line.include?("'mysql2'")
              @config[:db][:adapter] = "mysql2"
            elsif line.include?("'pg'")
              @config[:db][:adapter] = "pg"
            elsif line.include?("'sqlite3'")
              @config[:db][:adapter] = "sqlite3"
            end
            # Rails Version
            if line.match(/gem\ \'rails\'/)
              @config[:app][:version] = line.gsub(/gem\ \'rails\'\,/, '').gsub(/\'/, '').strip
            end
          end
        end
        # Application Class Name
        @config[:app][:name] = Rails.application.class.parent_name
      end

      def user_config
        # Database
        if @config[:db][:adapter].present? && yes?("\nCambium, in all its wisdom, thinks your database adapter as #{set_color(@config[:db][:adapter], :green, :bold)}. Is this correct? [yes, no]")
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

        # Database Name
        @config[:db][:name] = @config[:app][:name].underscore.downcase
        db_name = ask "\n#{set_color('Database Base Name:', :green, :bold)} [default: #{@config[:db][:name]}]"
        @config[:db][:name] = db_name unless db_name.blank?

        # Database Credentials
        @config[:db][:user] = confirm_ask("#{set_color('Database User', :green, :bold)}: [leave blank for no user]")
        if @config[:db][:user].present?
          @config[:db][:password] = confirm_ask("#{set_color('Database Password', :green, :bold)}: [leave blank for no password]")
        else
          @config[:db][:password] = ''
        end

        # Root URL (for mailers)
        @config[:app][:dev_url] = ask("\n#{set_color('Development URL', :green, :bold)}: [leave blank for localhost:3000]")
        @config[:app][:dev_url] = 'localhost:3000' if @config[:app][:dev_url].blank?
        @config[:app][:prod_url] = ask("#{set_color('Production URL', :green, :bold)}: [leave blank for localhost:3000]")
        @config[:app][:prod_url] = 'localhost:3000' if @config[:app][:prod_url].blank?
      end

      # ------------------------------------------ Application Settings & Config

      def add_application_config
        insert_into_file(
          "config/application.rb",
          file_contents("config/application.rb"),
          :after => "class Application < Rails::Application"
        )
      end

      # ------------------------------------------ Environment Settings

      def add_env_settings
        insert_into_file "config/environments/development.rb", 
          :after => "Rails.application.configure do" do
            "\n\n  config.action_mailer.default_url_options = { :host => '#{@config[:app][:dev_url]}' }\n"
        end
        insert_into_file "config/environments/production.rb", 
          :after => "Rails.application.configure do" do
            output = ''
            output += "\n\n  config.action_mailer.default_url_options = { :host => '#{@config[:app][:prod_url]}' }"
            output += "\n\n  config.assets.precompile += %w( admin/admin.css admin/admin.js admin/wysihtml5.css modernizr.js )\n"
            output
        end
      end

      # ------------------------------------------ Assets Initializer

      def add_assets_initializer
        template "config/initializers/assets.rb", 
          "config/initializers/assets.rb"
      end

      # ------------------------------------------ Database Setup

      def setup_database
        copy_file "#{Rails.root}/config/database.yml", "config/database.sample.yml"
        remove_file "config/database.yml"
        template "config/database.#{@config[:db][:adapter]}.yml.erb", "config/database.yml"
        rake "db:drop"
        rake "db:create"
        rake "db:migrate"
      end

      # ------------------------------------------ .gitignore

      def add_gitignore
        remove_file ".gitignore"
        template "gitignore", ".gitignore"
      end

      # ------------------------------------------ Gems & Gemfile

      def surface_gems_in_gemfile
        if yes? "Would you like to keep your existing Gemfile?"
          insert_into_file(
            "Gemfile",
            file_contents("Gemfile"),
            :after => "rubygems.org'"
          )
          say "\n#{set_color('Config completed! Please inspect your Gemfile, remove duplicates, then run `bundle install`.', 
            :green, :bold)}"
        else
          remove_file "Gemfile"
          template "Gemfile.erb", "Gemfile"
          run_cmd "bundle clean"
          run_cmd "bundle install"
          say "\n#{set_color('Config completed!', :green, :bold)}"
        end
      end

    end
  end
end
