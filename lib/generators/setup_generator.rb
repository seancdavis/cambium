require 'rails/generators'

class SetupGenerator < Rails::Generators::Base
  desc "Setup a new rails project"

  # Commandline options can be defined here using Thor-like options:
  class_option :my_opt, :type => :boolean, :default => false, :desc => "My Option"

  # I can later access that option using:
  # options[:my_opt]

  # ------------------------------------------ Class Methods

  def self.source_root
    @source_root ||= "#{gem_root}/lib/generators/templates"
  end

  # ------------------------------------------ Instance Methods

  def install_gemfile
    raise @source_root.to_s
  end

end
