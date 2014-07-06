# require 'thor'

namespace :setup do

  include SetupHelper, ThorHelper

  desc 'saying hello'
  task :gems do
    print_table(
      [
        [set_color("hello", :green, :bold), "world"]
      ],
      :indent => 9
    )
  end

  task :something_else do
    puts '123'
  end

end
