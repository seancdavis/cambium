module Cambium
  module GeneratorsHelper

    # ------------------------------------------ System Commands / Aliases

    # Shorthand for `bundle exec`
    # 
    def be
      "bundle exec"
    end

    # Runs a system command, but with pretty output
    # 
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

    # Make sure we get a matching answer before moving on. Useful for usernames,
    # passwords, and other items where user error is harmful (or painful)
    # 
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

    # ------------------------------------------ Templating

    # Get the path to a particular template
    # 
    def template_file(name)
      File.expand_path("../../templates/#{name}", __FILE__)
    end

    # Read a template and return its contents
    # 
    def file_contents(template)
      File.read(template_file(template))
    end

    # ------------------------------------------ Gems

    # Run `bundle install`
    # 
    def bundle
      run_cmd "bundle install"
    end

    # Get the local path where the gems are installed
    # 
    def gem_dir
      gem_dir = `bundle show rails`
      gem_dir = gem_dir.split('/')
      gem_dir[0..-3].join('/')
    end

    # Add gem to Gemfile
    # 
    def add_to_gemfile(name)
      insert_into_file "Gemfile", "\n\ngem '#{name}'", :after => "rubygems.org'"
    end

    # First, install the gem in the local gem directory, then add it to the
    # Gemfile.
    # 
    # Note: This will run bundle install after adding the gem, unless specified
    # otherwise.
    # 
    def install_gem(name, bundle? = true)
      run "gem install #{name} -i #{gem_dir}"
      add_to_gemfile(name)
      bundle if bundle?
    end

  end
end
