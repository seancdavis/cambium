require 'rake'
require 'rails/generators'
require "#{Gem::Specification.find_by_name("cambium").gem_dir}/lib/generators/cambium/helpers/generators_helper.rb"
include Cambium::GeneratorsHelper

module Cambium
  module Install
    class UsersGenerator < Rails::Generators::Base
      desc "Setup users model for new rails project"

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Install Devise

      def install_devise
        unless File.exist?("#{Rails.root}/config/initializers/devise.rb")
          generate "devise:install"
        end
        unless File.exist?("#{Rails.root}/app/models/user.rb")
          generate "devise User"
        end
      end

      # ------------------------------------------ User Model

      def add_admin_column_to_users
        file = Dir.glob("#{Rails.root}/db/migrate/*devise_create_users.rb").first
        insert_into_file(
          file, 
          "## Admin\n      t.boolean :is_admin, :default => false \n\n      ", 
          :before => "t.timestamps"
        )
      end

      def add_user_model_file
        remove_file "app/models/user.rb"
        template "app/models/user.rb", "app/models/user.rb"
      end

      def migrate_and_annotate
        rake "db:migrate"
        run_cmd "#{be} annotate"
      end

      # ------------------------------------------ Log In/Out Redirects

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
