namespace :setup do

  include SetupHelper

  desc 'saying hello'
  task :gems do
    say_hi
  end

  task :something_else do
    puts '123'
  end

end
