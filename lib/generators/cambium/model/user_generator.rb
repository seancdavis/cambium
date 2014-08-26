require 'rake'
require 'rails/generators'
require File.expand_path('../../helpers/_autoloader.rb', __FILE__)

module Cambium
  module Model
    class UserGenerator < Rails::Generators::Base
      desc "Setup users model for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      # We'll begin by installing the gems we need to work the user model
      # 
      def add_user_gems
        @user_gems = ['devise','annotate']
        install_gems @user_gems
        bundle
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
        copy_file "app/models/user.rb", "app/models/user.rb", :force => true
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
          template_snippet("app/controllers/application_controller.rb"),
          :after => ":exception"
        )
      end

      # Let the user know the gems we installed
      # 
      def finish_up
        gem_installation_notification(@user_gems)
      end

    end
  end
end
