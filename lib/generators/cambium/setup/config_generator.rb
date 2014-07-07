require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class ConfigGenerator < Rails::Generators::Base
      desc "Setup config files for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Config

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
              @config[:db][:adapter] = "sqlite3"
            elsif line.include?("'sqlite3'")
              @config[:db][:adapter] = "pg"
            end
            # Rails Version
            if line.match(/gem\ \'rails\'/)
              @config[:app][:version] = line.gsub(/gem\ \'rails\'\,/, '').gsub(/\'/, '').strip
            end
          end
        end
        # Application Class Name
        @config[:app][:name] = Rails.application.class.parent_name
        # Database Name
        @config[:db][:name] = @config[:app][:name].underscore.downcase
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

        # Database Credentials
        @config[:db][:user] = confirm_ask("Database #{set_color('user', :green, :bold)}: [leave blank for no user]")
        if @config[:db][:user].present?
          @config[:db][:password] = confirm_ask("Database #{set_color('password', :green, :bold)}: [leave blank for no password]")
        else
          @config[:db][:password] = ''
        end
      end

      # ------------------------------------------ Gems & Gemfile

      def install_gemfile
        remove_file "Gemfile"
        template "Gemfile.erb", "Gemfile"
        run_cmd "bundle clean"
      end

      # ------------------------------------------ Application Settings & Config

      def add_application_config
        insert_into_file(
          "config/application.rb",
          file_contents("config/application.rb"),
          :after => "class Application < Rails::Application"
        )
      end

      # ------------------------------------------ Database Setup

      def setup_database
        copy_file "#{Rails.root}/config/database.yml", "config/database.sample.yml"
        remove_file "config/database.yml"
        template "config/database.#{@config[:db][:adapter]}.yml.erb", "config/database.yml"
        run_cmd "#{rake} db:drop", :quiet => true
        run_cmd "#{rake} db:create"
        run_cmd "#{rake} db:migrate"
      end

      # ------------------------------------------ .gitignore

      def add_gitignore
        remove_file ".gitignore"
        template "gitignore", ".gitignore"
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
