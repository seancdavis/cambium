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

    # Run rake db:migrate
    # 
    def migrate
      rake "db:migrate"
    end

    # Annotate our models and tests
    # 
    def annotate
      run_cmd "#{be} annotate"
    end

    # Run migrate and annotate
    # 
    def migrate_and_annotate
      migrate
      annotate
    end

    # ------------------------------------------ Templating

    # Copy template file to project unless it's already there
    # 
    def copy_unless_exists(path, new_path = path)
      copy_file(path, new_path) unless File.exists?("#{Rails.root}/#{new_path}")
    end

    def copy_files(files, dir)
      files.each { |f| copy_unless_exists("#{dir}/#{f}") }
    end

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

    def template_snippet(template)
      require 'erb'
      ERB.new(File.read(template_file(template))).result(binding)
    end

    # Copies model concern templates to the project
    # 
    def add_model_concern(name)
      copy_unless_exists "app/models/concerns/#{name}.rb"
    end

    # Alias for previous method
    # 
    def model_concern(name)
      add_model_concern(name)
    end

    # Add multiple concerns
    # 
    def add_model_concerns(concerns)
      concerns.each { |c| add_model_concern(c) }
    end

    # Copy multiple directories
    # 
    def directories(dir_arr, container)
      dir_arr.each do |dir|
        directory "#{container}/#{dir}", "#{container}/#{dir}"
      end
    end

    # ------------------------------------------ Gems

    # Run `bundle install`
    # 
    def bundle
      run_cmd "bundle install"
      run_cmd "bundle clean"
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
    def add_to_gemfile(name, options = {})
      unless gem_exists?(name)
        if options[:require].present?
          text = "\n\ngem '#{name}', :require => '#{options[:require]}'"
        else
          text = "\n\ngem '#{name}'"
        end
        insert_into_file "Gemfile", text, :after => "rubygems.org'"
      end
    end

    # Find if a gem exists
    # 
    def gem_exists?(name)
      Gem::Specification::find_all_by_name(name).any?
    end

    # First, install the gem in the local gem directory, then add it to the
    # Gemfile (if it doesn't already exist).
    # 
    # Note: This will run bundle install after adding the gem, unless specified
    # otherwise.
    # 
    def install_gem(name, options = {})
      if gem_exists?(name)
        say "Found existing gem: #{name}"
      else
        run "gem install #{name} -i #{gem_dir}"
        add_to_gemfile(name, options)
        bundle if options[:bundle].nil? || options[:bundle] == true
      end
    end

    # Install an array of gems -- useful if needing to install more than one
    # gem.
    # 
    def install_gems(gem_arr)
      gem_arr.each { |gem_name| install_gem(gem_name, :bundle => false) }
      bundle
    end

    # Notifies the user of the gems that were installed and how desperately
    # important they are.
    # 
    def gem_installation_notification(gems)
      say "\nThis generator installed the following gems (and added them to "
      say "your Gemfile):\n\n"
      gems.each { |g| say "    #{g}" }
      say "\nThese gems *may* be necessary for Cambium to work properly. "
    end

    # ------------------------------------------ Miscellaneous

    # Return current time in migration timestamp format
    # 
    def timestamp
      Time.now.gmtime.strftime('%Y%m%d%H%M%S')
    end

    # Check to see if a class exists. This can be helpful in determining if
    # other generators have been run.
    #
    def class_exists?(class_name)
      defined?(class_name.constantize) == 'constant' && class_name.constantize.class == Class
    end

  end
end
