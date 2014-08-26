module Cambium
  module DependenciesHelper

    # This method accepts an array of dependencies as THE GENERATOR COMMAND. So,
    # for example, if we need to make sure `bundle exec rails generate
    # cambium:install:users` has been run, we would call
    # check_dependencies(['cambium:install:users']).
    # 
    # We use that value to determine the subsequent method to call. So,
    # check_dependencies(['cambium:install:users']) will call
    # require_cambium_install_users
    # 
    def check_dependencies(dependencies = [])
      cmds = []
      dependencies.each do |d| 
        cmds << d unless eval("#{d.split(':').join('_')}_generated?")
      end
      if cmds.size > 0
        display_dependency_errors(cmds)
      end
      exit
    end

    # Gives the user output of the errors
    # 
    def display_dependency_errors(cmds)
      say set_color(
        "\nERROR! You need to run the following command(s):\n",
        :red, 
        :bold
      )
      cmds.each { |cmd| say "    $ bundle exec rails g #{cmd}" }
      say set_color(
        "\nbefore running this generator.",
        :red,
        :bold
      )
    end

    ##########################################################################
    # The following methods are the individual checks and their appropriate
    # responses.                                          
    ##########################################################################

    def cambium_model_users_generated?
      class_exists?('User')
    end

  end
end
