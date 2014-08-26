require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Model
    class UserGenerator < Rails::Generators::Base
      desc "Setup users model for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      def add_user_gems
      end

      # Install Devise
      # 
      def install_devise
        unless File.exist?("#{Rails.root}/config/initializers/devise.rb")
          generate "devise:install"
        end
        unless File.exist?("#{Rails.root}/app/models/user.rb")
          generate "devise User"
        end
      end

      # Inject the is_admin column into the migration file if user plans on
      # using the admin module.
      # 
      def add_admin_column_to_users
        @admin = false
        if yes? "Would you like to add admin authentication to User model?"
          @admin = true
          file = Dir.glob("#{Rails.root}/db/migrate/*devise_create_users.rb").first
          insert_into_file(
            file, 
            "## Admin\n      t.boolean :is_admin, :default => false \n\n      ", 
            :before => "t.timestamps"
          )
        end
      end

      # Add our customized User model file
      # 
      def add_user_model_file
        copy_file "app/models/user.rb", "app/models/user.rb"
      end

      # Create model from migration
      # 
      def migrate_and_annotate
        rake "db:migrate"
        run_cmd "#{be} annotate"
      end

      # Add the default login/logout redirects
      # 
      def add_application_controller_redirects
        insert_into_file(
          "app/controllers/application_controller.rb",
          file_contents("app/controllers/application_controller.rb"),
          :after => ":exception"
        )
      end

    end
  end
end
