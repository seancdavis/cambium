module Cambium
  module GeneratorsHelper

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

    def rk
      "#{be} rake"
    end

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

  end
end
