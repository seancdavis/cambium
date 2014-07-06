require 'rake'
require 'rails/generators'

module Setup
  class GemfileGenerator < Rails::Generators::Base
    desc "Add default Gemfile"

    # ------------------------------------------ Options

    class_option :database, :aliases => :d, :default => "mysql", 
      :desc => "Specify database type."

    # ------------------------------------------ Class Methods

    source_root File.expand_path('../templates', __FILE__)

    # ------------------------------------------ Instance Methods

    def resolve_options
      case options[:database]
      when "sqlite"
        @database = "sqlite"
      when "postges", "postgresql", "pg"
        @database = "pg"
      else
        @database = "mysql2"
      end
    end

    def install_gemfile
      File.open("#{Rails.root}/Gemfile") do |f|
        f.each_line do |line|
          if line.match(/gem\ \'rails\'/)
            @rails_version = line.gsub(/gem\ \'rails\'\,/, '').gsub(/\'/, '').strip
          end
        end
      end
      template "Gemfile.erb", "Gemfile"
      say "\nYou now have a new Gemfile. Please run `bundle install` and then continue with setup", :green, :bold
    end

    # def bundle_install
    #   run_cmd "bundle install"
    # end

    # ------------------------------------------ Private Methods

    private

      def gem_root
        spec = Gem::Specification.find_by_name("cambium")
        gem_root = spec.gem_dir
      end

      def run_cmd(cmd)
        print_table(
          [
            [set_color("run", :green, :bold), cmd]
          ],
          :indent => 9
        )
        system(cmd)
      end

  end
end
