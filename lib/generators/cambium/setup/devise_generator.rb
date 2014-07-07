require 'rake'
require 'rails/generators'

module Cambium
  module Setup
    class DeviseGenerator < Rails::Generators::Base
      desc "Setup models for new rails project"

      # ------------------------------------------ Class Methods

      source_root File.expand_path('../../templates', __FILE__)

      # ------------------------------------------ Devise

      def install_devise
        unless File.exist?("#{Rails.root}/config/initializers/devise.rb")
          run_cmd "#{g} devise:install"
        end
        unless File.exist?("#{Rails.root}/app/models/user.rb")
          run_cmd "#{g} devise User"
          run_cmd "#{rake} db:migrate"
        end
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

      # ------------------------------------------

    end
  end
end
