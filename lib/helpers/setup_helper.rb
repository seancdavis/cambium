module SetupHelper

  include ThorHelper

  def root
    Gem::Specification.find_by_name("cambium").gem_dir
  end

  def template(name, location = name)
    require 'erb'
    template = ERB.new(File.read("#{root}/lib/templates/#{name}.erb"), 0, '<>').result
    yes? "Sure?"
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

  def bundle
    run_cmd "bundle install"
  end

end
