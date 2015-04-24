require 'rake'
require 'rails/generators'

module Cambium
  class GemfileGenerator < Rails::Generators::Base

    desc "Replace your existing Gemfile with Cambium's default Gemfile."

    source_root File.expand_path('../../templates', __FILE__)

    # Here we figure out some of the more complicated logic
    # before rendering the Gemfile template
    #
    def resolve_options
      @rails_version = `bundle exec rails -v`.to_s.split(' ').last
    end

    # Move our default Gemfile to the project's Gemfile.
    #
    def add_config_file
      template "Gemfile.erb", "Gemfile", :force => true
      gsub_file "Gemfile", /\n\n\n+?/, "\n\n"
    end

    private

      def gem_root
        Gem::Specification.find_by_name("cambium").gem_dir
      end

      def help_message(file)
        puts File.read("#{gem_root}/lib/help/#{file}.txt")
      end

  end
end
