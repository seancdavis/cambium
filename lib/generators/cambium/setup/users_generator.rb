require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class UsersGenerator < Rails::Generators::Base
      desc "Setup users model for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Install Devise

      def install_devise
        unless File.exist?("#{Rails.root}/config/initializers/devise.rb")
          run_cmd "#{g} devise:install"
        end
        unless File.exist?("#{Rails.root}/app/models/user.rb")
          run_cmd "#{g} devise User"
          run_cmd "#{rake} db:migrate"
        end
      end

      # ------------------------------------------ User Model

      def add_admin_column_to_users
        file = Dir.glob("#{Rails.root}/db/migrate/*devise_create_users.rb").first
        insert_into_file(
          file, 
          "\n## Admin\nt.boolean :is_admin, :default => false, \n", 
          :before => "t.timestamps"
        )
        run_cmd "#{rake} db:migrate"
      end

      def add_user_model_file
        remove_file "app/models/user.rb"
        template "app/models/user.rb", "app/models/user.rb"
        run_cmd "#{be} annotate"
      end

      def add_default_user
        User.reset_column_information
        create_user
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
          match = ask("CONFIRM #{question}")
          if answer == match
            answer
          else
            say set_color("Did not match.", :red)
            confirm_ask(question)
          end
        end

        def create_user
          email = confirm_ask "#{set_color('Default User Email', :green, :bold)}:"
          password = confirm_ask "#{set_color('Default User Password', :green, :bold)}:"
          u = User.new(
            :email => email,
            :password => password, 
            :password_confirmation => password,
            :is_admin => true
          )
          if u.save
            say "User created successfully!"
          else
            create_user
          end
        end

    end
  end
end
